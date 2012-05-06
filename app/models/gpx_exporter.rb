class GpxExporter

  def self.export
    pois = Waypoint.order("created_at ASC").all

    g = GarminUtils::WaypointListGenerator.new
    pois.each do |poi|
      g.add(
        poi.lat,
        poi.lon,
        poi.name,
        poi.attributes[:cmt] || '',
        poi.created_at,
        poi.elevation,
        poi.sym
      )
    end

    return g.to_xml
  end

end