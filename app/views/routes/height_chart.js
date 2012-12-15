//Format A
nv.addGraph({
  generate: function() {
    var width = 700;
    var height = 300;

    var chart = nv.models.stackedArea()
                .width(width)
                .height(height)
                .margin({top: 20, right: 20, bottom: 20, left: 20})


    d3.select('#route_height_chart')
      .attr('width', width)
      .attr('height', height)
      .datum(route_data())
      .call(chart);

    return chart;
  },
  callback: function(graph) {
    window.onresize = function() {
      var width = nv.utils.windowSize().width - 40,
          height = nv.utils.windowSize().height - 40,
          margin = graph.margin();


      if (width < margin.left + margin.right + 20)
        width = margin.left + margin.right + 20;

      if (height < margin.top + margin.bottom + 20)
        height = margin.top + margin.bottom + 20;


      graph
         .width(width)
         .height(height);

      d3.select('#route_height_chart')
        .attr('width', width)
        .attr('height', height)
        .call(graph);
    };
  }
});



function route_data() {
  <%
    _data = Array.new
    distance = 0
    resource.route_elements.each do |r|
      _data << {x: distance, y: r.waypoint.elevation}
      distance += r.distance.to_i
    end
  %>

  var d = <%= raw _data.to_json %>;

  return [
    {
      values: d,
      key: "Sine Wave",
      color: "#ff7f0e"
    },
    {
      values: d,
      key: "Cosine Wave",
      color: "#2ca02c"
    }
  ];
}