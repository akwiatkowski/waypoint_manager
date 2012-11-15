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

# Usage:
# use in view with bootstrap
#   = simple_model_details(User.first)
#
# Keep in mind:
# * it uses only locales in format like this 'en.user.email'
#
# Custom attributes:
#   = simple_model_details(User.first, attrs: ["email", "name"])
# Add created_at, updated_at:
#   = simple_model_details(User.first, timestamps: true)
# Custom table class
#   = simple_model_details(User.first, table_class: "table")
#
# Example:
#= raw simple_model_details(resource, attrs: ["name"], timestamps: true, table_class: "table")

def simple_model_details(m, options = { })
  if options[:table_class]
    table_class = options[:table_class]
  else
    table_class = "table table-striped table-bordered"
  end

  special_attrs = ["id", "created_at", "updated_at"]
  object_tableize = m.class.to_s.tableize.singularize

  if options[:attrs]
    attrs = options[:attrs].collect{|k| k.to_s}
  else
    # remove special attributes
    attrs = m.attributes.keys.sort
    special_attrs.each do |s|
      attrs.delete(s)
    end
  end

  # model's regular attributes
  details = Array.new
  attrs.each do |d|
    #details << [I18n.t("#{object_tableize}.#{d}"), m.attributes[d]]
    # http://apidock.com/rails/ActiveModel/Translation/human_attribute_name
    details << [m.class.human_attribute_name(d), m.attributes[d]]
  end

  # timestamps
  if options[:timestamps]
    #details << [m.class.human_attribute_name("created_at"), l(m.attributes["created_at"], format: :long)]
    #details << [m.class.human_attribute_name("updated_at"), l(m.attributes["updated_at"], format: :long)]
    details << [I18n.t("created_at"), l(m.attributes["created_at"], format: :long)]
    details << [I18n.t("updated_at"), l(m.attributes["updated_at"], format: :long)]
  end

  s = "<table class=\"#{table_class}\">"
  details.each do |d|
    s += "<tr><td>#{d[0]}</td><td>#{d[1]}</td></tr>\n"
  end
  s += "</table>"

  return s
end