jQuery ->
  $('.btn.route-height-chart').click ->
    $('#route_height_chart').show()
    route_id = $('#route_id').val()
    $.getScript("/routes/" + route_id + '/height_chart.js')

map = undefined

@routeInitMap = (id, title) ->
  # Define a new map.  We want it to be loaded into the 'map_canvas' div in the view
  map = new OpenLayers.Map("map_canvas")

  # Add a LayerSwitcher controller
  map.addControl new OpenLayers.Control.LayerSwitcher()

  # OpenStreetMaps
  osm = new OpenLayers.Layer.OSM()

  # Google Maps (ROAD)
  gmap = new OpenLayers.Layer.Google("Google Maps",
    type: google.maps.MapTypeId.ROAD
  )

  # Google Maps (SATELLITE)
  gsat = new OpenLayers.Layer.Google("Google Satellite",
    type: google.maps.MapTypeId.SATELLITE
  )

  # Add the layers defined above to the map
  map.addLayers [osm, gmap, gsat]

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
  map.addLayer vectorLayer

  # Get the polylines from Rails
  url = "/routes/" + id + ".geojson"
  OpenLayers.Request.GET({
    url: url,
    headers: {'Accept':'application/json'},
    success: (req) ->
      g = new OpenLayers.Format.GeoJSON()
      feature_collection = g.read(req.responseText)
      vectorLayer.destroyFeatures()
      vectorLayer.addFeatures(feature_collection)
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
