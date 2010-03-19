# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100319054011) do

  create_table "acts", :force => true do |t|
    t.string   "name"
    t.string   "status",     :default => "confirmed", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "acts_performers", :id => false, :force => true do |t|
    t.integer "act_id",       :null => false
    t.integer "performer_id", :null => false
  end

  add_index "acts_performers", ["act_id"], :name => "index_acts_performers_on_act_id"
  add_index "acts_performers", ["performer_id"], :name => "index_acts_performers_on_performer_id"

  create_table "keywords", :force => true do |t|
    t.integer  "show_id",     :null => false
    t.string   "words"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "imported_at"
  end

  add_index "keywords", ["show_id"], :name => "index_keywords_on_show_id"

  create_table "performances", :force => true do |t|
    t.integer  "show_id"
    t.boolean  "sold_out"
    t.datetime "happens_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "performers", :force => true do |t|
    t.string   "name"
    t.string   "country"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reviews", :force => true do |t|
    t.string   "name",       :null => false
    t.integer  "show_id"
    t.float    "rating"
    t.string   "source"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "reviews", ["show_id"], :name => "index_reviews_on_show_id"

  create_table "shows", :force => true do |t|
    t.string   "name"
    t.integer  "act_id"
    t.string   "status",                                              :default => "confirmed"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "sold_out_percent",      :precision => 6, :scale => 3, :default => 0.0
    t.decimal  "rating",                :precision => 3, :scale => 2, :default => 2.5
    t.boolean  "featured",                                            :default => false
    t.integer  "tweet_count"
    t.integer  "confirmed_tweet_count"
  end

  add_index "shows", ["act_id"], :name => "index_shows_on_act_id"
  add_index "shows", ["featured"], :name => "index_shows_on_featured"

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "encrypted_password", :limit => 128
    t.string   "salt",               :limit => 128
    t.string   "confirmation_token", :limit => 128
    t.string   "remember_token",     :limit => 128
    t.boolean  "email_confirmed",                   :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin",                             :default => false
  end

  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["id", "confirmation_token"], :name => "index_users_on_id_and_confirmation_token"
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

end
