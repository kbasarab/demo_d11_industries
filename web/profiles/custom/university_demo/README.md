# University Demo Installation Profile

This installation profile creates a beautiful university website using the DXPR theme with a modern homepage featuring hero sections and card layouts.

## Features

- **DXPR Theme Integration**: Uses the powerful DXPR theme for professional styling
- **Homepage Hero Section**: Eye-catching hero section with call-to-action buttons
- **Program Cards**: Displays academic programs in attractive card format
- **News Section**: Latest news and announcements in card layout
- **Statistics Section**: Key university statistics prominently displayed
- **Responsive Design**: Mobile-friendly layout that works on all devices
- **Sample Content**: Pre-populated with realistic university content

## Content Types

- **Academic Program**: For degree programs and courses
- **News Article**: For campus news and announcements
- **Event**: For campus events and activities
- **Basic Page**: For static content pages

## Taxonomies

- **Program Categories**: Undergraduate, Graduate, Certificate, Online
- **News Categories**: Campus Life, Research, Athletics, Alumni

## Installation

1. Install Drupal using this profile
2. The profile will automatically:
   - Set DXPR theme as the default theme
   - Create content types and taxonomies
   - Generate sample content
   - Set up navigation menus
   - Configure the homepage layout

## Customization

The homepage template is located at:
`web/profiles/custom/university_demo/templates/page--front.html.twig`

Custom CSS is in:
`web/profiles/custom/university_demo/templates/university-homepage.css`

## Views

The profile includes pre-configured views:
- **Programs View**: Displays programs as cards
- **News View**: Shows latest news articles

## Dependencies

- DXPR Theme
- Core Drupal modules (Node, Block, Views, Layout Builder, etc.)
- Additional modules: Paragraphs, Pathauto, Token, Metatag, Admin Toolbar

## Support

This installation profile is designed to work with Drupal 11 and provides a solid foundation for university websites with modern design and functionality.
