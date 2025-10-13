#!/bin/bash

# Traffic Simulation Script for New Relic Testing
# Generates realistic web traffic with configurable parameters

# Default configuration
DEFAULT_REQUESTS=300
DEFAULT_MIN_DELAY=0.1
DEFAULT_MAX_DELAY=0.5
DEFAULT_MAX_RUNTIME=300
DEFAULT_CONCURRENCY=5
DEFAULT_USER_AGENT="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
DEFAULT_BASE_URL="https://live-kb-university.pantheonsite.io"

# Configuration variables
TOTAL_REQUESTS=${1:-$DEFAULT_REQUESTS}
MIN_DELAY=${2:-$DEFAULT_MIN_DELAY}
MAX_DELAY=${3:-$DEFAULT_MAX_DELAY}
MAX_RUNTIME=${4:-$DEFAULT_MAX_RUNTIME}
CONCURRENCY=${5:-$DEFAULT_CONCURRENCY}
USER_AGENT=${6:-$DEFAULT_USER_AGENT}
BASE_URL=${7:-$DEFAULT_BASE_URL}

# URL patterns for realistic traffic simulation
URL_PATTERNS=(
    "/"
    "/node/3"
    "/node/4"
    "/node/2"
    "/node/6"
)

# HTTP methods for variety
HTTP_METHODS=("GET" "GET" "GET" "GET" "GET" "GET" "GET")

# Function to show usage
show_usage() {
    echo "Usage: $0 [total_requests] [min_delay] [max_delay] [max_runtime] [concurrency] [user_agent] [base_url]"
    echo ""
    echo "Parameters:"
    echo "  total_requests  Number of requests to generate (default: $DEFAULT_REQUESTS)"
    echo "  min_delay       Minimum delay between requests in seconds (default: $DEFAULT_MIN_DELAY)"
    echo "  max_delay       Maximum delay between requests in seconds (default: $DEFAULT_MAX_DELAY)"
    echo "  max_runtime     Maximum runtime in seconds (default: $DEFAULT_MAX_RUNTIME)"
    echo "  concurrency     Number of concurrent requests (default: $DEFAULT_CONCURRENCY)"
    echo "  user_agent      User agent string (default: Chrome on macOS)"
    echo "  base_url        Base URL to send requests to (default: $DEFAULT_BASE_URL)"
    echo ""
    echo "Examples:"
    echo "  $0                                    # Use all defaults"
    echo "  $0 500                               # 500 requests with default settings"
    echo "  $0 200 0.1 0.3 120 10               # 200 requests, 0.1-0.3s delays, 2min max, 10 concurrent"
    echo "  $0 100 0.2 0.5 60 3 \"Custom Agent\" \"https://example.com\""
    echo ""
    echo "Current configuration:"
    echo "  Total requests: $TOTAL_REQUESTS"
    echo "  Delay range: ${MIN_DELAY}-${MAX_DELAY} seconds"
    echo "  Max runtime: ${MAX_RUNTIME} seconds"
    echo "  Concurrency: $CONCURRENCY"
    echo "  User agent: $USER_AGENT"
    echo "  Base URL: $BASE_URL"
}

# Function to generate random delay
get_random_delay() {
    local min=$1
    local max=$2
    echo "scale=2; $min + ($max - $min) * $RANDOM / 32767" | bc -l
}

# Function to get random URL pattern
get_random_url() {
    local pattern_count=${#URL_PATTERNS[@]}
    local random_index=$((RANDOM % pattern_count))
    echo "${URL_PATTERNS[$random_index]}"
}

# Function to get random HTTP method
get_random_method() {
    local method_count=${#HTTP_METHODS[@]}
    local random_index=$((RANDOM % method_count))
    echo "${HTTP_METHODS[$random_index]}"
}

# Function to make HTTP request
make_request() {
    local url="$1"
    local method="$2"
    local user_agent="$3"
    
    # Use curl with various options for realistic simulation
    curl -s -o /dev/null -w "%{http_code},%{time_total},%{url_effective}\n" \
        -H "User-Agent: $user_agent" \
        -H "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8" \
        -H "Accept-Language: en-US,en;q=0.5" \
        -H "Accept-Encoding: gzip, deflate, br" \
        -H "DNT: 1" \
        -H "Connection: keep-alive" \
        -H "Upgrade-Insecure-Requests: 1" \
        -X "$method" \
        --max-time 30 \
        --connect-timeout 10 \
        "$url" 2>/dev/null || echo "ERROR,0,$url"
}

# Function to log request details
log_request() {
    local request_num="$1"
    local url="$2"
    local method="$3"
    local response="$4"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    echo "[$timestamp] Request #$request_num: $method $url -> $response"
}

# Function to make a single request (for parallel execution)
make_single_request() {
    local request_id="$1"
    local url_path="$2"
    local method="$3"
    local user_agent="$4"
    local base_url="$5"
    
    local full_url="${base_url}${url_path}"
    local response=$(make_request "$full_url" "$method" "$user_agent")
    local http_code=$(echo "$response" | cut -d',' -f1)
    local response_time=$(echo "$response" | cut -d',' -f2)
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    # Thread-safe logging
    echo "[$timestamp] Request #$request_id: $method $full_url -> $response" >> "/tmp/traffic_sim_$$.log"
    
    # Return statistics
    echo "$http_code,$response_time"
}

# Function to run parallel requests
run_parallel_requests() {
    local num_requests="$1"
    local concurrency="$2"
    local min_delay="$3"
    local max_delay="$4"
    local user_agent="$5"
    local base_url="$6"
    local max_runtime="$7"
    
    local start_time=$(date +%s)
    local request_count=0
    local success_count=0
    local error_count=0
    local total_response_time=0
    
    # Create log file
    echo "" > "/tmp/traffic_sim_$$.log"
    
    echo "Starting parallel traffic simulation..."
    echo "  Concurrency: $concurrency"
    echo "  Max runtime: ${max_runtime}s"
    echo "  Target requests: $num_requests"
    echo ""
    
    # Use GNU parallel if available, otherwise use background processes
    if command -v parallel &> /dev/null; then
        # Create request list
        local request_list="/tmp/request_list_$$.txt"
        for ((i=1; i<=num_requests; i++)); do
            local url_path=$(get_random_url)
            local method=$(get_random_method)
            echo "$i,$url_path,$method" >> "$request_list"
        done
        
        # Run with GNU parallel
        cat "$request_list" | parallel -j "$concurrency" --colsep ',' \
            "make_single_request {1} {2} {3} '$user_agent' '$base_url'" > "/tmp/responses_$$.txt"
        
        # Process results
        while IFS=',' read -r http_code response_time; do
            ((request_count++))
            total_response_time=$(echo "$total_response_time + $response_time" | bc -l)
            
            if [[ "$http_code" =~ ^[2-3][0-9][0-9]$ ]]; then
                ((success_count++))
            else
                ((error_count++))
            fi
            
            # Check runtime limit
            local current_time=$(date +%s)
            if [ $((current_time - start_time)) -ge $max_runtime ]; then
                echo "  Runtime limit reached (${max_runtime}s), stopping..."
                break
            fi
        done < "/tmp/responses_$$.txt"
        
        # Cleanup
        rm -f "$request_list" "/tmp/responses_$$.txt"
    else
        # Fallback: use background processes with job control
        local pids=()
        local active_jobs=0
        
        for ((i=1; i<=num_requests; i++)); do
            # Check runtime limit
            local current_time=$(date +%s)
            if [ $((current_time - start_time)) -ge $max_runtime ]; then
                echo "  Runtime limit reached (${max_runtime}s), stopping..."
                break
            fi
            
            # Wait for available slot
            while [ $active_jobs -ge $concurrency ]; do
                # Check for completed jobs
                for j in "${!pids[@]}"; do
                    if ! kill -0 "${pids[$j]}" 2>/dev/null; then
                        wait "${pids[$j]}"
                        unset pids[$j]
                        ((active_jobs--))
                    fi
                done
                sleep 0.1
            done
            
            # Start new request
            local url_path=$(get_random_url)
            local method=$(get_random_method)
            make_single_request "$i" "$url_path" "$method" "$user_agent" "$base_url" &
            pids+=($!)
            ((active_jobs++))
            
            # Small delay between starting requests
            local delay=$(get_random_delay "$min_delay" "$max_delay")
            sleep "$delay"
        done
        
        # Wait for all remaining jobs
        for pid in "${pids[@]}"; do
            wait "$pid" 2>/dev/null
        done
        
        # Process log file for statistics
        while IFS= read -r line; do
            if [[ "$line" =~ "-> "([0-9]+),([0-9.]+) ]]; then
                local http_code="${BASH_REMATCH[1]}"
                local response_time="${BASH_REMATCH[2]}"
                ((request_count++))
                total_response_time=$(echo "$total_response_time + $response_time" | bc -l)
                
                if [[ "$http_code" =~ ^[2-3][0-9][0-9]$ ]]; then
                    ((success_count++))
                else
                    ((error_count++))
                fi
            fi
        done < "/tmp/traffic_sim_$$.log"
    fi
    
    # Display log
    if [ -f "/tmp/traffic_sim_$$.log" ]; then
        cat "/tmp/traffic_sim_$$.log"
        rm -f "/tmp/traffic_sim_$$.log"
    fi
    
    # Calculate final statistics
    local end_time=$(date +%s)
    local total_duration=$((end_time - start_time))
    local avg_response_time=0
    local success_rate=0
    
    if [ $request_count -gt 0 ]; then
        avg_response_time=$(echo "scale=3; $total_response_time / $request_count" | bc -l)
        success_rate=$(echo "scale=1; $success_count * 100 / $request_count" | bc -l)
    fi
    
    echo ""
    echo "Traffic simulation completed!"
    echo "Summary:"
    echo "  Total requests: $request_count"
    echo "  Successful requests: $success_count"
    echo "  Failed requests: $error_count"
    echo "  Success rate: ${success_rate}%"
    echo "  Average response time: ${avg_response_time}s"
    echo "  Total duration: ${total_duration}s"
    if [ $total_duration -gt 0 ]; then
        echo "  Average requests per minute: $(echo "scale=1; $request_count * 60 / $total_duration" | bc -l)"
    fi
}

# Main execution
main() {
    # Check if help is requested
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        show_usage
        exit 0
    fi
    
    # Validate inputs
    if ! [[ "$TOTAL_REQUESTS" =~ ^[0-9]+$ ]] || [ "$TOTAL_REQUESTS" -lt 1 ]; then
        echo "Error: Total requests must be a positive integer"
        exit 1
    fi
    
    if ! [[ "$MIN_DELAY" =~ ^[0-9]+\.?[0-9]*$ ]] || (( $(echo "$MIN_DELAY < 0" | bc -l) )); then
        echo "Error: Minimum delay must be a non-negative number"
        exit 1
    fi
    
    if ! [[ "$MAX_DELAY" =~ ^[0-9]+\.?[0-9]*$ ]] || (( $(echo "$MAX_DELAY < $MIN_DELAY" | bc -l) )); then
        echo "Error: Maximum delay must be greater than or equal to minimum delay"
        exit 1
    fi
    
    if ! [[ "$MAX_RUNTIME" =~ ^[0-9]+$ ]] || [ "$MAX_RUNTIME" -lt 1 ]; then
        echo "Error: Max runtime must be a positive integer"
        exit 1
    fi
    
    if ! [[ "$CONCURRENCY" =~ ^[0-9]+$ ]] || [ "$CONCURRENCY" -lt 1 ]; then
        echo "Error: Concurrency must be a positive integer"
        exit 1
    fi
    
    # Check if bc is available for floating point math
    if ! command -v bc &> /dev/null; then
        echo "Error: 'bc' command is required for delay calculations. Please install it."
        echo "On macOS: brew install bc"
        echo "On Ubuntu/Debian: sudo apt-get install bc"
        exit 1
    fi
    
    # Check if curl is available
    if ! command -v curl &> /dev/null; then
        echo "Error: 'curl' command is required. Please install it."
        exit 1
    fi
    
    echo "Starting traffic simulation..."
    echo "Configuration:"
    echo "  Total requests: $TOTAL_REQUESTS"
    echo "  Delay range: ${MIN_DELAY}-${MAX_DELAY} seconds"
    echo "  Max runtime: ${MAX_RUNTIME} seconds"
    echo "  Concurrency: $CONCURRENCY"
    echo "  User agent: $USER_AGENT"
    echo "  Base URL: $BASE_URL"
    echo "  URL patterns: ${#URL_PATTERNS[@]} different paths"
    echo ""
    
    # Run parallel requests
    run_parallel_requests "$TOTAL_REQUESTS" "$CONCURRENCY" "$MIN_DELAY" "$MAX_DELAY" "$USER_AGENT" "$BASE_URL" "$MAX_RUNTIME"
}

# Run the main function
main "$@"
