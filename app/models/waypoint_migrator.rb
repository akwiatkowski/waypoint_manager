class WaypointMigrator
  def self.import_file(user, path)
    json_data = File.read(path)
    import(user, json_data)
  end

  def self.import(user, json_data)
    data = JSON.parse(json_data)

    data.each do |hat|
      area_type_name = hat["name"]

      at = AreaType.where(name: area_type_name).first
      at = AreaType.new(hat) if at.nil?
      at.save

      hat["areas"].each do |ha|
        area_name = ha["name"]
        a = at.areas.where(name: area_name).first
        if a.nil?
          a = Area.new
          a.area_type = at
          ha.keys.each do |k|
            a.send("#{k}=", ha[k]) if not ["waypoints"].include?(k)
          end
        end
        a.save

        # waypoints
        hws = ha["waypoints"]
        hws.each do |hw|
          waypoint_name = hw["name"]
          lat = hw["lat"]
          lon = hw["lon"]
          w = Waypoint.where(["area_id = ? and user_id = ? and waypoints.name = ? and lat = ? and lon = ?", a.id, user.id, waypoint_name, lat, lon]).first
          if w.nil?
            w = Waypoint.new
          end

          hw.keys.each do |k|
            w.send("#{k}=", hw[k]) #if not ["waypoints"].include?(k)
          end
          # overwrite area_id
          w.area = a

          w.save
        end

        a.save
      end

    end

  end

  def self.export(user)
    data = AreaType.all.collect do |at|
      hat = at.attributes
      hat.delete "id"
      hat.delete "created_at"
      hat.delete "updated_at"

      hat["areas"] = Array.new

      at.areas.all.each do |a|
        ha = a.attributes
        ha.delete "id"
        ha.delete "created_at"
        ha.delete "updated_at"

        ha["waypoints"] = Array.new

        ws = a.waypoints
        ws = ws.where(user_id: user.id) if user
        ws.all.each do |w|
          hw = w.attributes
          hw.delete "id"
          #hw.delete "created_at"
          hw.delete "updated_at"

          ha["waypoints"] << hw
        end

        hat["areas"] << ha

      end

      hat
    end

    data
  end
end