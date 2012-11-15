module ApplicationHelper
  def waypoint_map_link_to(waypoint)
    s = link_to "google", waypoint.google_maps_path, class: "btn btn-mini btn-info"
    s += " "
    s += link_to "ump", waypoint.ump_path, class: "btn btn-mini btn-info"

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

def simple_model_details(m)
  table_class = "table table-striped table-bordered"

  special_attrs = ["id", "created_at", "updated_at"]
  attrs = m.attributes.keys.sort
  object_tableize = m.class.to_s.tableize.singularize

  # remove special attributes
  special_attrs.each do |s|
    attrs.delete(s)
  end

  # model's regular attributes
  details = Array.new
  attrs.each do |d|
    details << [I18n.t("#{object_tableize}.#{d}"), m.attributes[d]]
  end

  s = "<table class=\"#{table_class}\">"
  details.each do |d|
    s += "<tr><td>#{d[0]}</td><td>#{d[1]}</td></tr>\n"
  end
  s += "</table>"

  return s
end