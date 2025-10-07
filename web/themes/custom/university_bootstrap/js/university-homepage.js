/**
 * University Homepage JavaScript
 */
(function (Drupal, drupalSettings) {
  'use strict';

  Drupal.behaviors.universityHomepage = {
    attach: function (context, settings) {
      // Smooth scrolling for anchor links
      const anchorLinks = context.querySelectorAll('a[href^="#"]');
      anchorLinks.forEach(function(link) {
        link.addEventListener('click', function(e) {
          e.preventDefault();
          const target = document.querySelector(this.getAttribute('href'));
          if (target) {
            target.scrollIntoView({
              behavior: 'smooth',
              block: 'start'
            });
          }
        });
      });

      // Add animation classes when elements come into view
      const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
      };

      const observer = new IntersectionObserver(function(entries) {
        entries.forEach(function(entry) {
          if (entry.isIntersecting) {
            entry.target.classList.add('animate-in');
          }
        });
      }, observerOptions);

      // Observe cards and stats
      const animatedElements = context.querySelectorAll('.card, .stat-item');
      animatedElements.forEach(function(element) {
        observer.observe(element);
      });
    }
  };

})(Drupal, drupalSettings);
