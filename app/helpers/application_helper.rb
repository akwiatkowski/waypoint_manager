module ApplicationHelper
  def waypoint_map_link_to(waypoint, klass = "btn-mini")
    s = link_to "Google", waypoint.google_maps_path, class: "btn #{klass} btn-info"
    s += " "
    s += link_to "UMP", waypoint.ump_path, class: "btn #{klass} btn-info"

    return s
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
          "http://a-kwiatkowski.deviantart.com/gallery/",
          "http://www.panoramio.com/user/4973339",
          "https://github.com/akwiatkowski"
        ]
    }
  end
end
