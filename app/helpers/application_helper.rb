module ApplicationHelper
  def waypoint_map_link_to(waypoint)
    s = link_to "google", waypoint.google_maps_path
    s += " "
    s += link_to "ump", waypoint.ump_path

    return s
  end
end
