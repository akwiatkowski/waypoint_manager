$('.btn.route-height-chart').click ->
  $('#route_height_chart').show()
  route_id = $('#route_id').val()
  $.getScript("/routes/" + route_id + '/height_chart.js')
