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

ActiveRecord::Schema.define(:version => 20120907043823) do

  create_table "matches", :force => true do |t|
    t.integer  "user_id",      :limit => 8
    t.integer  "trip_id",      :limit => 8
    t.boolean  "is_creator"
    t.datetime "time_created"
  end

  create_table "trips", :id => false, :force => true do |t|
    t.integer "id",          :limit => 8, :null => false
    t.integer "origin",      :limit => 2
    t.integer "destination", :limit => 2
  end

  create_table "users", :id => false, :force => true do |t|
    t.integer  "id",                :limit => 8, :null => false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "password_digest"
    t.string   "password_salt"
    t.boolean  "confirmed"
    t.string   "one_time_password"
    t.datetime "time_created"
    t.datetime "last_login"
  end

end
