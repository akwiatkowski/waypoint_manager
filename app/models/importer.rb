class Importer
  def self.process_path(path)
    g = GarminUtils::GpxWaypointParser.new
    dir = Dir[File.join(path, "*")]
    dir.each do |f|
      if f =~ /\.gpx$/i
        g.add_file(f)
      end
    end

    pois = g.pois
    pois = pois.sort { |a, b| a[:time] <=> b[:time] }

    pois.each do |p|
      h = { }
      [:sym, :name, :lat, :lon].each do |k|
        h[k] = p[k]
      end
      h[:elevation] = p[:alt]

      w = Waypoint.new(h)
      w.created_at = p[:time]
      w.updated_at = p[:time]
      w.imported_at = Time.now

      w.save!
    end

    return g.pois
  end
end