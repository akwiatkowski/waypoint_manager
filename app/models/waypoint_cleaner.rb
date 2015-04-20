# reload!; w = WaypointCleaner.new; w.make_it_so; puts w.to_s

class WaypointCleaner
  attr_reader :similars
  attr_accessor :min_distance

  def initialize
    @similars = Hash.new
    @min_distance = 50
    @equal_name = false
  end

  def make_it_so
    @waypoints = Waypoint.all
    @waypoints.each do |waypoint|
      puts "process #{waypoint.id} - #{waypoint.name}"
      s = @waypoints.select do |w|
        result = (waypoint.distance_to(w) <= @min_distance) && (waypoint.id != w.id)
        if @equal_name
          result && waypoint.name == w.name
        else
          result
        end
      end

      s = s.collect do |w|
        [w, w.distance_to(waypoint)]
      end

      if s.size > 0
        @similars[waypoint] = s
      end
    end
  end

  def to_s
    s = ""
    @similars.keys.each do |waypoint|
      @similars[waypoint].each do |w_array|
        w = w_array[0]
        s += "#{waypoint.id}; #{waypoint.name}; #{w.id}; #{w.name}; #{waypoint.distance_to(w)};\n"
      end
    end
    s
  end

  def to_delete
    a = Array.new
    @similars.keys.each do |waypoint|
      @similars[waypoint].each do |w_array|
        w = w_array[0]
        if w.id > waypoint.id
          a << w
        end
      end
    end
    a
  end

  def delete!
    to_delete.each do |w|
      puts w.attributes.inspect
      w.delete
    end
  end
end