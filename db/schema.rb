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

ActiveRecord::Schema.define(:version => 20110203214852) do

  create_table "gender_constraints", :force => true do |t|
    t.string   "constraint"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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
  end

  create_table "locations", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "parent_id"
    t.integer  "capacity"
    t.text     "comment"
  end

end