class Importer
  def self.process_path(path, current_user)
    g = GpxUtils::WaypointsImporter.new
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
      w.user = current_user
      w.is_private = true # private by default


      w.save!
    end

    return g.pois
  end

  def self.prepare_seeds
    data = Array.new

    Area.all.each do |a|
      h = { area: a.attributes, waypoints: Array.new }

      a.waypoints.where(is_private: false).each do |w|
        h[:waypoints] << w.attributes
      end

      data << h
    end

    f = File.new(Rails.root.join("db", "seeds", "areas.yml"), "w")
    f.puts(data.to_yaml)
    f.close
  end

end