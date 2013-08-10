module ApplicationHelper
  def waypoint_map_link_to(waypoint, klass = "btn-mini")
    s = link_to "Google", waypoint.google_maps_path, class: "btn #{klass} btn-info", target: '_blank'
    s += " "
    s += link_to "UMP", waypoint.ump_path, class: "btn #{klass} btn-info", target: '_blank'

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
