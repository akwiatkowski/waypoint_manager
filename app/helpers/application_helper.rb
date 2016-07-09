module ApplicationHelper
  def waypoint_map_link_to(waypoint, klass = "btn-sm", use_all = false)
    s = link_to "Google", waypoint.google_maps_path, class: "btn #{klass} btn-info", target: '_blank'
    s += " "
    s += link_to "OSM", waypoint.osm_path, class: "btn #{klass} btn-info", target: '_blank'
    s += " "
    s += link_to "UMP", waypoint.ump_path, class: "btn #{klass} btn-info", target: '_blank'


    if use_all
      s += " "
      s += link_to "Cycle", waypoint.cycle_map_path, class: "btn #{klass} btn-info", target: '_blank'
      s += " "
      s += link_to "Transport", waypoint.transport_map_path, class: "btn #{klass} btn-info", target: '_blank'
      s += " "
      s += link_to "Mapquest", waypoint.mapquest_path, class: "btn #{klass} btn-info", target: '_blank'
      s += " "
      s += link_to "Humanitarian", waypoint.humanitarian_map_path, class: "btn #{klass} btn-info", target: '_blank'
    end

    return s
  end

  def title_string(array)
    return array.join(" - ")
  end

  def nice_links
    { "Competitors" =>
        [
          "http://www.szlaki.net.pl/",
          "http://trail.pl/",
          "http://www.traseo.pl/",
          "http://www.everytrail.com/",
        ],
      "Personal" =>
        [
          "http://500px.com/bobik314",
          "http://www.panoramio.com/user/4973339",
          "http://a-kwiatkowski.deviantart.com/gallery/",
          "https://github.com/akwiatkowski"
        ]
    }
  end
end
