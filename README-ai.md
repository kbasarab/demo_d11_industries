# University Demo Installation Profile - Setup Guide

## Overview

This is a Drupal 11 installation profile that creates a complete, professional university website with custom theming, content types, and sample content. The profile demonstrates best practices for creating industry-specific Drupal sites with custom themes and content.

## What This Profile Creates

### 🏛️ **Content Types**
- **Academic Program**: For degree programs and courses
- **News Article**: For campus news and announcements  
- **Event**: For campus events and activities
- **Basic Page**: For static content

### 🎨 **Custom Theme (university_bootstrap)**
- Professional university branding with custom logo
- Bootstrap 5-based responsive design
- Hero sections with navigation
- Icon-based visual system for cards and content
- Mobile-responsive layout

### 📄 **Sample Content**
- 6 academic programs with detailed descriptions
- 3 news articles with rich content
- 3 campus events
- Homepage with hero section, stats, and featured content

### ⚙️ **Configuration**
- Proper field configurations for all content types
- Display modes (default and card views)
- Text format configuration (filtered_html)
- Menu structure and navigation

## File Structure

```
web/profiles/custom/university_demo/
├── university_demo.info.yml          # Profile definition
├── university_demo.install           # Installation logic
└── config/install/                   # Configuration files
    ├── node.type.*.yml              # Content type definitions
    ├── field.field.node.*.yml       # Field configurations
    ├── field.storage.node.*.yml     # Field storage
    ├── core.entity_view_display.*.yml # Display configurations
    ├── core.entity_form_display.*.yml # Form configurations
    ├── views.view.*.yml             # View configurations
    └── filter.format.filtered_html.yml # Text format

web/themes/custom/university_bootstrap/
├── university_bootstrap.info.yml     # Theme definition
├── university_bootstrap.libraries.yml # CSS/JS libraries
├── css/university-homepage.css      # Custom styling
├── js/university-homepage.js        # Custom JavaScript
├── images/university-logo.svg       # Custom logo
└── templates/                       # Twig templates
    ├── page.html.twig              # General page template
    ├── page--front.html.twig       # Homepage template
    ├── node--program--*.html.twig  # Program templates
    └── node--news--*.html.twig     # News templates
```

## Key Components Explained

### 1. Installation Profile (`university_demo.info.yml`)

```yaml
name: 'University Demo'
type: profile
description: 'A complete university website with custom theme and content'
core_version_requirement: ^11
dependencies:
  - drupal:node
  - drupal:field
  - drupal:views
  - drupal:menu_ui
  - drupal:taxonomy
  - drupal:image
  - drupal:text
  - drupal:filter
  - drupal:file
  - drupal:user
  - drupal:system
  - drupal:path
  - drupal:menu_link_content
  - drupal:block
  - drupal:views_ui
  - drupal:field_ui
  - drupal:node
  - drupal:taxonomy
  - drupal:image
  - drupal:text
  - drupal:filter
  - drupal:file
  - drupal:user
  - drupal:system
  - drupal:path
  - drupal:menu_link_content
  - drupal:block
  - drupal:views_ui
  - drupal:field_ui
  - drupal:paragraphs
  - drupal:pathauto
  - drupal:token
  - drupal:metatag
  - drupal:admin_toolbar
  - drupal:views_infinite_scroll
themes:
  - university_bootstrap
```

### 2. Installation Logic (`university_demo.install`)

The install script handles:
- Theme configuration (frontend + admin)
- Content type creation
- Field setup (body fields, hero images)
- Sample content generation
- Menu creation
- Taxonomy setup

### 3. Custom Theme Structure

**Theme Info (`university_bootstrap.info.yml`)**:
```yaml
name: 'University Bootstrap'
type: theme
description: 'Custom university theme based on Bootstrap 5'
base theme: olivero
libraries:
  - university_bootstrap/bootstrap
  - university_bootstrap/university-homepage
```

**Libraries (`university_bootstrap.libraries.yml`)**:
```yaml
bootstrap:
  css:
    theme:
      https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css: { type: external, minified: true }
  js:
    https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js: { type: external, minified: true }

university-homepage:
  css:
    theme:
      css/university-homepage.css: {}
  js:
    js/university-homepage.js: {}
  dependencies:
    - olivero/global-styling
```

### 4. Template System

**Homepage Template (`page--front.html.twig`)**:
- Header with navigation and logo
- Hero section with call-to-action
- Stats section
- Featured programs and news
- Footer with links

**Interior Page Template (`page.html.twig`)**:
- Header with navigation
- Hero section with page title
- Main content area
- Footer

**Content Templates**:
- `node--program--full.html.twig`: Full program display
- `node--program--card.html.twig`: Program card for listings
- `node--news--full.html.twig`: Full news article display
- `node--news--card.html.twig`: News card for listings

## How to Adapt for Different Industries

### 🏥 **Healthcare/Medical Site**
**Content Types**: Service, Doctor Profile, Medical News, Appointment
**Theme Colors**: Medical blues, whites, greens
**Icons**: Medical cross, stethoscope, heart, hospital
**Sample Content**: Medical services, doctor bios, health news

### 🏢 **Corporate/Business Site**
**Content Types**: Service, Team Member, Case Study, Blog Post
**Theme Colors**: Professional blues, grays, accent colors
**Icons**: Briefcase, chart, team, building
**Sample Content**: Services, team profiles, case studies

### 🏪 **E-commerce/Retail Site**
**Content Types**: Product, Category, Blog Post, Testimonial
**Theme Colors**: Brand colors, vibrant accents
**Icons**: Shopping cart, product, star, tag
**Sample Content**: Products, categories, reviews

### 🎓 **Educational Institution**
**Content Types**: Course, Faculty, News, Event
**Theme Colors**: Academic colors (blues, golds, school colors)
**Icons**: Graduation cap, book, diploma, campus
**Sample Content**: Courses, faculty profiles, campus news

## Adaptation Process

### 1. **Update Content Types**
- Modify `node.type.*.yml` files
- Update field configurations
- Adjust display and form configurations

### 2. **Customize Theme**
- Update `university_bootstrap.info.yml` with new theme name
- Modify CSS colors and styling in `university-homepage.css`
- Update logo in `images/` directory
- Adjust templates for industry-specific content

### 3. **Update Sample Content**
- Modify `university_demo.install` content arrays
- Update program/news/event data
- Adjust field values and descriptions

### 4. **Configure Views**
- Update `views.view.*.yml` files
- Adjust display settings and filters
- Update view names and descriptions

## Installation Commands

```bash
# Install the profile
drush si university_demo -y

# Clear cache
drush cr

# View the site
drush uli
```

## Key Features

### ✅ **Professional Design**
- Custom logo and branding
- Responsive Bootstrap 5 layout
- Professional color scheme
- Icon-based visual system

### ✅ **Content Management**
- Rich text editing with proper formatting
- Image fields for hero images
- Structured content types
- SEO-friendly URLs

### ✅ **Performance**
- Optimized CSS and JavaScript
- CDN-based Bootstrap loading
- Efficient template structure
- Fast-loading icon system

### ✅ **Accessibility**
- Semantic HTML structure
- Proper heading hierarchy
- Alt text for images
- Keyboard navigation support

## Troubleshooting

### Common Issues:
1. **Theme not loading**: Check `university_bootstrap.info.yml` syntax
2. **Content not displaying**: Verify field configurations and display settings
3. **Images not showing**: Check image field configurations and templates
4. **Styling issues**: Clear cache and check CSS file paths

### Debug Commands:
```bash
# Check theme status
drush theme:list

# Check content types
drush config:get node.type.program

# Clear all caches
drush cr

# Check for errors
drush watchdog:show
```

## Future Enhancements

### Potential Additions:
- **Layout Builder**: For more flexible page layouts
- **Webform**: For contact forms and applications
- **Search**: Enhanced search functionality
- **Multilingual**: Multiple language support
- **E-commerce**: Product catalogs and shopping
- **Events**: Calendar integration
- **Social Media**: Integration with social platforms

## Dependencies

### Core Modules:
- Node, Field, Views, Menu UI, Taxonomy, Image, Text, Filter, File, User, System, Path, Block

### Contrib Modules:
- Paragraphs, Pathauto, Token, Metatag, Admin Toolbar, Views Infinite Scroll

### External Libraries:
- Bootstrap 5.3.0 (CDN)
- Font Awesome 6.0.0 (CDN)
- Google Fonts (Inter)

## Common Issues and Solutions

### 🚨 **Critical Configuration Requirements**

When creating new installation profiles, ensure these essential configurations are included:

#### **1. Theme Info File Requirements**
```yaml
# REQUIRED: All themes must include core_version_requirement
name: 'Your Theme Name'
type: theme
description: 'Your theme description'
core_version_requirement: ^11  # ← CRITICAL: This is required for Drupal 11
base theme: olivero
libraries:
  - your_theme/your_library
```

#### **2. Content Type Configuration**
```yaml
# REQUIRED: All content types must have display_submitted set
langcode: en
status: true
dependencies: {  }
name: 'Content Type Name'
type: content_type_id
description: 'Content type description'
help: ''
new_revision: true
preview_mode: 1
display_submitted: false  # ← CRITICAL: Prevents template errors
```

#### **3. Complete Display Configuration Set**
Every content type needs ALL of these files:
- `node.type.{content_type}.yml` - Content type definition
- `field.field.node.{content_type}.body.yml` - Body field instance
- `field.storage.node.body.yml` - Body field storage (shared)
- `core.entity_view_display.node.{content_type}.default.yml` - View display
- `core.entity_form_display.node.{content_type}.default.yml` - Form display
- `filter.format.filtered_html.yml` - Text format configuration

### 🔧 **Installation Profile Checklist**

Before testing a new profile, verify:

#### **Profile Info File**
- [ ] `core_version_requirement: ^11` is present
- [ ] All required dependencies are listed
- [ ] Theme is specified in `themes:` section

#### **Theme Configuration**
- [ ] `core_version_requirement: ^11` in theme info file
- [ ] All required libraries are defined
- [ ] CSS and JS files exist and are properly referenced

#### **Content Types**
- [ ] All content types have `display_submitted: false`
- [ ] Body field storage and instances are created
- [ ] Display and form configurations exist for each content type
- [ ] Text format configuration is included

#### **Install Script**
- [ ] Theme configuration sets both default and admin themes
- [ ] Content creation uses `'format' => 'filtered_html'`
- [ ] Body field creation logic is included
- [ ] Sample content arrays are properly structured

### 🐛 **Common Error Messages and Fixes**

#### **Error: "core_version_requirement key must be present"**
**Fix**: Add `core_version_requirement: ^11` to theme info file

#### **Error: "Call to a member function displaySubmitted() on null"**
**Fix**: Set `display_submitted: false` in all content type configurations

#### **Error: "Configuration objects have unmet dependencies"**
**Fix**: Ensure all referenced configurations exist and dependencies are correct

#### **Error: "Unable to determine class for field type"**
**Fix**: Use correct field types (`text_with_summary` not `text_long`)

### 📋 **File Structure Validation**

Ensure your profile has this complete structure:
```
web/profiles/custom/{profile_name}/
├── {profile_name}.info.yml
├── {profile_name}.install
└── config/install/
    ├── node.type.*.yml                    # All content types
    ├── field.field.node.*.body.yml        # Body field instances
    ├── field.storage.node.body.yml        # Body field storage
    ├── field.storage.node.field_*.yml     # Other field storage
    ├── field.field.node.*.field_*.yml     # Other field instances
    ├── core.entity_view_display.*.yml     # View displays
    ├── core.entity_form_display.*.yml     # Form displays
    └── filter.format.filtered_html.yml    # Text format

web/themes/custom/{theme_name}/
├── {theme_name}.info.yml                  # With core_version_requirement
├── {theme_name}.libraries.yml
├── css/{theme_name}-homepage.css
├── js/{theme_name}-homepage.js
├── images/{theme_name}-logo.svg
└── templates/
    ├── page.html.twig
    ├── page--front.html.twig
    └── node--{content_type}--*.html.twig
```

### 🎯 **Industry Adaptation Best Practices**

#### **1. Content Type Naming**
- Use descriptive, industry-specific names
- Keep field names consistent across content types
- Include industry terminology in descriptions

#### **2. Theme Customization**
- Update color variables in CSS for industry branding
- Create industry-specific logos and icons
- Use appropriate typography and spacing

#### **3. Sample Content**
- Write realistic, industry-specific content
- Include proper HTML structure with headings and lists
- Use industry terminology and concepts

#### **4. Navigation and Menus**
- Create industry-appropriate menu items
- Use professional, industry-standard language
- Include relevant call-to-action buttons

### 🚀 **Testing Protocol**

Before considering a profile complete:

1. **Installation Test**
   ```bash
   drush si {profile_name} -y
   ```

2. **Frontend Verification**
   - [ ] Homepage loads without errors
   - [ ] Navigation works correctly
   - [ ] Content displays properly
   - [ ] Theme styling is applied

3. **Content Management Test**
   - [ ] Can create new content of each type
   - [ ] Forms display correctly
   - [ ] Content saves and displays properly

4. **Admin Interface Test**
   - [ ] Admin theme loads correctly
   - [ ] Can access content management
   - [ ] No PHP errors in logs

## Support

This installation profile is designed to be:
- **Self-contained**: All necessary files included
- **Well-documented**: Clear structure and comments
- **Extensible**: Easy to modify for different industries
- **Maintainable**: Clean, organized code structure
- **Error-resistant**: Includes all required configurations

For questions or issues, refer to the Drupal documentation or create an issue in the project repository.

Updates readme
