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

  def self.import_seeds!
    e = "importer@localhost.org"
    u = User.find_by_email(e)
    if u.nil?
      u = User.new(email: e, password: e, password_confirmation: e, name: 'importer')
      u.save!
    end

    f = File.new(Rails.root.join("db", "seeds", "areas.yml"))
    data = YAML::load(File.open(f))

    # area loop
    data.each do |a|
      area = Area.find_by_name(a[:area]['name'])
      if area.nil?
        area = Area.new
      end

      a[:area].keys.each do |k|
        area.send(k.to_s + "=", a[:area][k])
      end
      area.save!

      # waypoints loop
      a[:waypoints].each do |w|
        waypoint = Waypoint.where(area_id: a[:area]['id']).where(lat: w['lat']).where(lon: w['lon']).first
        if waypoint.nil?
          waypoint = Waypoint.new
        end

        w.keys.each do |k|
          waypoint.send(k.to_s + "=", w[k])
        end
        waypoint.save!

        waypoint.area = area
        waypoint.save!
      end
    end

    return true
  end

end