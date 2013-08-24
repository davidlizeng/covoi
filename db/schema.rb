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

ActiveRecord::Schema.define(:version => 20130410034146) do

  create_table "airports", :force => true do |t|
    t.string "code"
    t.string "city"
    t.string "state"
  end

  create_table "matches", :force => true do |t|
    t.integer  "user_id"
    t.integer  "trip_id"
    t.datetime "time_created"
  end

  create_table "origins", :force => true do |t|
    t.string "name"
    t.string "address"
    t.string "city"
    t.string "state"
    t.string "zip"
  end

  create_table "trips", :force => true do |t|
    t.integer  "creator_id"
    t.datetime "time"
    t.integer  "origin_id",    :limit => 2
    t.integer  "airport_id",   :limit => 2
    t.datetime "time_created"
    t.integer  "group_id"
    t.boolean  "locked"
  end

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "phone"
    t.string   "password_digest"
    t.string   "password_salt"
    t.string   "stripe_customer_id"
    t.string   "one_time_password"
    t.boolean  "confirmed"
    t.boolean  "password_reset_active"
    t.boolean  "admin"
    t.boolean  "facebook",              :default => false
    t.datetime "time_created"
    t.datetime "time_confirmed"
  end

end
