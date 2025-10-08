/**
 * Healthcare Demo Homepage JavaScript
 */

(function ($, Drupal) {
  'use strict';

  Drupal.behaviors.healthcareHomepage = {
    attach: function (context, settings) {
      // Add smooth scrolling to anchor links
      $('a[href*="#"]:not([href="#"])').click(function() {
        if (location.pathname.replace(/^\//, '') == this.pathname.replace(/^\//, '') && location.hostname == this.hostname) {
          var target = $(this.hash);
          target = target.length ? target : $('[name=' + this.hash.slice(1) + ']');
          if (target.length) {
            $('html, body').animate({
              scrollTop: target.offset().top - 80
            }, 1000);
            return false;
          }
        }
      });

      // Add animation classes on scroll
      $(window).scroll(function() {
        $('.stat-item, .service-card, .news-card').each(function() {
          var elementTop = $(this).offset().top;
          var elementBottom = elementTop + $(this).outerHeight();
          var viewportTop = $(window).scrollTop();
          var viewportBottom = viewportTop + $(window).height();

          if (elementBottom > viewportTop && elementTop < viewportBottom) {
            $(this).addClass('animate-in');
          }
        });
      });

      // Initialize tooltips if Bootstrap is available
      if (typeof bootstrap !== 'undefined') {
        var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
        var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
          return new bootstrap.Tooltip(tooltipTriggerEl);
        });
      }
    }
  };

})(jQuery, Drupal);
