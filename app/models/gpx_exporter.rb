class GpxExporter

  def self.export(_private = nil)
    pois = Waypoint.order("created_at ASC")
    unless _private.nil?
      puts _private.inspect
      pois = pois.where(is_private: _private)
    end
    pois = pois.all

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