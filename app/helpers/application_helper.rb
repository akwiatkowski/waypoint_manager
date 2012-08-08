module ApplicationHelper
  def waypoint_map_link_to(waypoint)
    s = link_to "google", waypoint.google_maps_path
    s += " "
    s += link_to "ump", waypoint.ump_path

    return s
  end
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
