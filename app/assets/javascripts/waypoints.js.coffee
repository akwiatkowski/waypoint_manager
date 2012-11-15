# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$('.btn.url-link').click ->
  window.open($('input#waypoint_url')[0].value,'_blank')