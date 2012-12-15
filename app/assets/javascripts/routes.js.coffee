$('.btn.route-height-chart').click ->
  route_id = $('#route_id').val()
  $.getScript("/routes/" + route_id + '/height_chart.js')
