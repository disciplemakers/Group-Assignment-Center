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

ActiveRecord::Schema.define(:version => 20120202190335) do

  create_table "assignments", :force => true do |t|
    t.integer  "group_id"
    t.integer  "person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "assignments", ["group_id", "person_id"], :name => "index_assignments_on_group_id_and_person_id", :unique => true
  add_index "assignments", ["group_id"], :name => "index_assignments_on_group_id"
  add_index "assignments", ["id"], :name => "index_assignments_on_id", :unique => true
  add_index "assignments", ["person_id"], :name => "index_assignments_on_person_id"

  create_table "custom_fields", :force => true do |t|
    t.string   "name"
    t.string   "people_field"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "custom_fields", ["id"], :name => "index_custom_fields_on_id", :unique => true
  add_index "custom_fields", ["name"], :name => "index_custom_fields_on_name"
  add_index "custom_fields", ["people_field"], :name => "index_custom_fields_on_people_field"

  create_table "events", :force => true do |t|
    t.integer  "remote_event_id"
    t.integer  "remote_report_id"
    t.integer  "location_id"
    t.integer  "group_id"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status_id"
  end

  add_index "events", ["group_id"], :name => "index_events_on_group_id", :unique => true
  add_index "events", ["id"], :name => "index_events_on_id", :unique => true
  add_index "events", ["location_id"], :name => "index_events_on_location_id"
  add_index "events", ["remote_event_id"], :name => "index_events_on_remote_event_id", :unique => true
  add_index "events", ["status_id"], :name => "index_events_on_status_id"

  create_table "gender_constraints", :force => true do |t|
    t.string   "constraint"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "gender_constraints", ["id"], :name => "index_gender_constraints_on_id", :unique => true

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.integer  "capacity"
    t.boolean  "can_contain_people"
    t.boolean  "can_contain_groups"
    t.integer  "location_id"
    t.text     "comment"
    t.boolean  "unique_membership"
    t.boolean  "required_membership"
    t.integer  "gender_constraint_id"
    t.string   "label_text"
    t.boolean  "label_text_prepend_to_child_label"
    t.integer  "label_field"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "depth"
    t.integer  "remote_event_id"
  end

  add_index "groups", ["id", "lft", "rgt"], :name => "index_groups_on_id_and_lft_and_rgt", :unique => true
  add_index "groups", ["id"], :name => "index_groups_on_id", :unique => true
  add_index "groups", ["lft", "rgt"], :name => "index_groups_on_lft_and_rgt", :unique => true
  add_index "groups", ["location_id"], :name => "index_groups_on_location_id"
  add_index "groups", ["name", "remote_event_id"], :name => "index_groups_on_name_and_remote_event_id"
  add_index "groups", ["parent_id"], :name => "index_groups_on_parent_id"
  add_index "groups", ["remote_event_id"], :name => "index_groups_on_remote_event_id"

  create_table "locations", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "parent_id"
    t.integer  "capacity"
    t.text     "comment"
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "depth"
  end

  add_index "locations", ["id"], :name => "index_locations_on_id", :unique => true
  add_index "locations", ["name"], :name => "index_locations_on_name"

  create_table "people", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "gender"
    t.string   "registration_type"
    t.string   "school"
    t.string   "graduation_year"
    t.string   "housing_assignment"
    t.string   "small_group_assignment"
    t.string   "campus_group_room"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "confirmation_number"
    t.integer  "event_id"
    t.string   "track"
  end

  add_index "people", ["confirmation_number"], :name => "index_people_on_confirmation_number", :unique => true
  add_index "people", ["event_id"], :name => "index_people_on_event_id"
  add_index "people", ["id"], :name => "index_people_on_id", :unique => true

  create_table "statuses", :force => true do |t|
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "statuses", ["id"], :name => "index_statuses_on_id", :unique => true

end
