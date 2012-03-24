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

ActiveRecord::Schema.define(:version => 20120324001003) do

  create_table "shows", :force => true do |t|
    t.string   "heading_one"
    t.string   "heading_two"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "heading"
    t.float    "score"
  end

  add_index "shows", ["score"], :name => "index_shows_on_score"

  create_table "tweets", :force => true do |t|
    t.string   "tweet_id"
    t.string   "to_user_id"
    t.string   "from_user_id"
    t.string   "profile_image_url"
    t.string   "source"
    t.string   "text"
    t.string   "from_user"
    t.integer  "show_id"
    t.string   "classification"
    t.boolean  "confirmed",         :default => false, :null => false
    t.boolean  "ignore",            :default => false, :null => false
    t.text     "raw"
    t.integer  "user_id"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
  end

  add_index "tweets", ["classification"], :name => "index_tweets_on_classification"
  add_index "tweets", ["confirmed"], :name => "index_tweets_on_confirmed"
  add_index "tweets", ["ignore"], :name => "index_tweets_on_ignore"
  add_index "tweets", ["show_id"], :name => "index_tweets_on_show_id"
  add_index "tweets", ["tweet_id"], :name => "index_tweets_on_tweet_id"
  add_index "tweets", ["user_id"], :name => "index_tweets_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "username"
    t.integer  "sign_in_count",      :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

end
