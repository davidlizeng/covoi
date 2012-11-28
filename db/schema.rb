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

ActiveRecord::Schema.define(:version => 20121124050121) do

  create_table "airports", :force => true do |t|
    t.string "code"
    t.string "city"
    t.string "state"
  end

  create_table "matches", :id => false, :force => true do |t|
    t.integer  "id",           :limit => 8, :null => false
    t.integer  "user_id",      :limit => 8
    t.integer  "trip_id",      :limit => 8
    t.datetime "time_created"
  end

  create_table "origins", :force => true do |t|
    t.string "name"
    t.string "address"
    t.string "city"
    t.string "state"
    t.string "zip"
  end

  create_table "trips", :id => false, :force => true do |t|
    t.integer  "id",           :limit => 8, :null => false
    t.integer  "creator_id",   :limit => 8
    t.datetime "time"
    t.integer  "origin_id",    :limit => 2
    t.integer  "airport_id",   :limit => 2
    t.datetime "time_created"
  end

  create_table "users", :id => false, :force => true do |t|
    t.integer  "id",                    :limit => 8, :null => false
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
    t.datetime "time_created"
    t.datetime "time_confirmed"
  end

end
