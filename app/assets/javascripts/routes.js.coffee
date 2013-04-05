jQuery ->
  $('.btn.route-height-chart').click ->
    $('#route_height_chart').show()
    route_id = $('#route_id').val()
    $.getScript("/routes/" + route_id + '/height_chart.js')

  # show JS map
  $('.map_link').click (e) ->
    e.stopImmediatePropagation();
    $(this).hide()
    $('#map_canvas').show()
    $('html, body').animate({
      scrollTop: $('#map_canvas').offset().top
    }, 800)
    routeInitMap($('#route_id').val(), $('#route_name').val());
    return false;


@routeInitMap = (id, title) ->
  # Define a new map.  We want it to be loaded into the 'map_canvas' div in the view
  map = new OpenLayers.Map("map_canvas")

  # Add a LayerSwitcher controller
  map.addControl new OpenLayers.Control.LayerSwitcher()

  # OpenStreetMaps
  osm = new OpenLayers.Layer.OSM()
  # UMP
  ump_servers = [
    "http://1.tiles.ump.waw.pl/ump_tiles/${z}/${x}/${y}.png",
    "http://2.tiles.ump.waw.pl/ump_tiles/${z}/${x}/${y}.png",
    "http://3.tiles.ump.waw.pl/ump_tiles/${z}/${x}/${y}.png",
  ]
  ump = new OpenLayers.Layer.OSM("UMP", ump_servers, {numZoomLevels: 20, alpha: true, isBaseLayer: true});

#  # Google Maps (ROAD)
#  gmap = new OpenLayers.Layer.Google("Google Maps",
#    type: google.maps.MapTypeId.ROAD
#  )
#
#  # Google Maps (SATELLITE)
#  gsat = new OpenLayers.Layer.Google("Google Satellite",
#    type: google.maps.MapTypeId.SATELLITE
#  )

  # Add the layers defined above to the map
  #map.addLayers [osm, gmap, gsat]
  map.addLayers [ump, osm]

  # Set some styles
  myStyleMap = new OpenLayers.StyleMap(
    strokeColor: "red"
    strokeOpacity: 1.0
    strokeWidth: 2
  )

  # Create a new vector layer including the above StyleMap
  vectorLayer = new OpenLayers.Layer.Vector(title,
    styleMap: myStyleMap
  )

  # Get the polylines from Rails
  url = "/routes/" + id + ".geojson"
  OpenLayers.Request.GET({
    url: url,
    #headers: {'Accept':'application/json'},
    success: (req) ->
      g = new OpenLayers.Format.GeoJSON({
        'internalProjection': new OpenLayers.Projection("EPSG:900913"),
        'externalProjection': new OpenLayers.Projection("EPSG:4326")
      })
      console.log(g.isValidType(req.responseText))
      features = g.read(req.responseText)
      console.log(features)

      # Iterate over the features and extend the bounds to the bounds of the geometries
      i = 0
      bounds = undefined
      while i < features.length
        console.log(features[i].geometry.getBounds())
        unless bounds
          bounds = features[i].geometry.getBounds()
        else
          bounds.extend features[i].geometry.getBounds()
        ++i

#      vectorLayer.destroyFeatures()
      vectorLayer.addFeatures features

      # Set the extent of the map to the 'bounds'
      map.addLayer(vectorLayer);
      map.zoomToExtent bounds

      console.log('------------')
      console.log(vectorLayer.first.geometry.components)
  })

#  OpenLayers.Request.GET url, {}, null, (response) ->
#    geojson_format = new OpenLayers.Format.GeoJSON(
#      internalProjection: new OpenLayers.Projection("EPSG:900913")
#      externalProjection: new OpenLayers.Projection("EPSG:4326")
#    )
#
#    #Read the GeoJSON
#    features = geojson_format.read(response.responseText, "FeatureCollection")
#    bounds = undefined
#    if features
#      features = [features]  unless features.constructor is Array
#
#      # Iterate over the features and extend the bounds to the bounds of the geometries
#      i = 0
#
#      while i < features.length
#        unless bounds
#          bounds = features[i].geometry.getBounds()
#        else
#          bounds.extend features[i].geometry.getBounds()
#        ++i
#
#      # Add features to the 'vectorLayer'
#      vectorLayer.addFeatures features
#
#      # Set the extent of the map to the 'bounds'
#      map.zoomToExtent bounds
