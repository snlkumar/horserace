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

ActiveRecord::Schema.define(:version => 20140128112603) do

  create_table "active_admin_comments", :force => true do |t|
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "bank_details", :force => true do |t|
    t.string   "bsb"
    t.string   "account"
    t.string   "bank_name"
    t.string   "account_name"
    t.integer  "client_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "clients", :force => true do |t|
    t.string   "client_name"
    t.float    "balance"
    t.integer  "tier_id"
    t.integer  "reseller_id"
    t.string   "phone"
    t.string   "custom_password"
    t.string   "respond_via"
    t.boolean  "admin",                     :default => false
    t.string   "inital_balance"
    t.string   "status",                    :default => "Inactive"
    t.string   "trading_start_date"
    t.boolean  "is_this_trial"
    t.integer  "trail_duration"
    t.string   "client_number"
    t.string   "address"
    t.string   "consultant_contact_number"
    t.string   "consultant_name"
    t.date     "dob"
    t.string   "enquiry"
    t.datetime "created_at",                                        :null => false
    t.datetime "updated_at",                                        :null => false
    t.float    "initial_balance"
  end

  create_table "posts", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "races", :force => true do |t|
    t.string   "name"
    t.date     "date"
    t.time     "time"
    t.string   "horse"
    t.string   "horse_no"
    t.string   "info"
    t.string   "status"
    t.float    "default_odd"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "location"
    t.string   "description"
    t.string   "race_type"
    t.string   "ticket_number"
  end

  create_table "resellers", :force => true do |t|
    t.string   "name"
    t.string   "address"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "tiers", :force => true do |t|
    t.string   "name"
    t.float    "weight"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "transactions", :force => true do |t|
    t.float    "withdraw"
    t.float    "deposit"
    t.integer  "owner"
    t.float    "balance_before"
    t.float    "balance_after"
    t.integer  "client_id"
    t.integer  "race_id"
    t.integer  "bank_detail_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.string   "race_status"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "",    :null => false
    t.string   "encrypted_password",     :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0,     :null => false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "reseller_id"
    t.integer  "client_id"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.boolean  "admin",                  :default => false
    t.string   "balance_after_bet"
    t.string   "enquiry"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "users_races", :force => true do |t|
    t.integer  "client_id"
    t.integer  "race_id"
    t.float    "processing_balance"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.float    "win"
    t.float    "lost"
    t.float    "bet_amount"
  end

  add_index "users_races", ["client_id", "race_id"], :name => "index_users_races_on_user_id_and_race_id"

  create_table "withdraws", :force => true do |t|
    t.float    "amount"
    t.integer  "user_id"
    t.integer  "bank_detail_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

end
