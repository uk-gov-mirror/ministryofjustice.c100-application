// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require_tree .

// from govuk_frontend_toolkit gem
//= require vendor/polyfills/bind
//= require govuk_toolkit
//= stub govuk/selection-buttons

// GOV.UK Frontend
//= require govuk-frontend/govuk/all

$(document).ready(function() {
  // Show and hide toggled content
  new GOVUK.ShowHideContent().init();

  // Initialize JS in /modules
  window.moj.init();
});
