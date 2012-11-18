# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121117133240) do

  create_table "area_types", :force => true do |t|
    t.string   "name"
    t.string   "sym"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "areas", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.float    "avg_lat"
    t.float    "avg_lon"
    t.text     "desc"
    t.string   "url"
    t.string   "photo_url"
    t.integer  "area_type_id"
  end

  create_table "route_elements", :force => true do |t|
    t.integer  "waypoint_id",               :null => false
    t.integer  "distance"
    t.integer  "d_elevation"
    t.integer  "route_id"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.integer  "real_distance"
    t.integer  "real_d_elevation"
    t.integer  "real_time_distance"
    t.string   "url"
    t.integer  "next_route_element_id"
    t.integer  "previous_route_element_id"
  end

  create_table "routes", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
    t.integer  "area_id"
    t.integer  "user_id"
    t.boolean  "is_private",            :default => false, :null => false
    t.integer  "last_route_element_id"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "",    :null => false
    t.string   "encrypted_password",     :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.string   "name"
    t.boolean  "admin",                  :default => false, :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "waypoints", :force => true do |t|
    t.float    "lat"
    t.float    "lon"
    t.integer  "elevation"
    t.string   "name"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.datetime "imported_at"
    t.string   "sym"
    t.integer  "area_id"
    t.boolean  "is_private",   :default => false, :null => false
    t.string   "url"
    t.integer  "user_id"
    t.string   "phone"
    t.string   "email"
    t.string   "official_url"
    t.string   "photo_url"
  end

end
