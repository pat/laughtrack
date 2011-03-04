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

ActiveRecord::Schema.define(:version => 20110304053405) do

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

  create_table "festivals", :force => true do |t|
    t.string   "name"
    t.integer  "year"
    t.date     "starts_on"
    t.date     "ends_on"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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
    t.boolean  "sold_out",   :default => false
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

  create_table "show_histories", :force => true do |t|
    t.integer  "show_id",                                                              :null => false
    t.decimal  "sold_out_percent",      :precision => 6, :scale => 3, :default => 0.0
    t.decimal  "rating",                :precision => 5, :scale => 2, :default => 0.0
    t.integer  "confirmed_tweet_count",                               :default => 0
    t.integer  "positive_tweet_count",                                :default => 0
    t.date     "day"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "show_histories", ["show_id"], :name => "index_show_histories_on_show_id"

  create_table "shows", :force => true do |t|
    t.string   "name"
    t.integer  "act_id"
    t.string   "status",                                                :default => "confirmed"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "sold_out_percent",        :precision => 6, :scale => 3, :default => 0.0
    t.decimal  "rating",                  :precision => 5, :scale => 2, :default => 0.0
    t.boolean  "featured",                                              :default => false
    t.integer  "tweet_count"
    t.integer  "confirmed_tweet_count"
    t.string   "url"
    t.integer  "unconfirmed_tweet_count"
    t.integer  "positive_tweet_count"
    t.integer  "festival_id",                                                                    :null => false
    t.integer  "micf_id",                                                                        :null => false
  end

  add_index "shows", ["act_id"], :name => "index_shows_on_act_id"
  add_index "shows", ["featured"], :name => "index_shows_on_featured"
  add_index "shows", ["festival_id"], :name => "index_shows_on_festival_id"
  add_index "shows", ["micf_id"], :name => "index_shows_on_micf_id"

  create_table "tweets", :force => true do |t|
    t.string   "tweet_id"
    t.string   "to_user_id"
    t.string   "from_user_id"
    t.string   "profile_image_url"
    t.string   "source"
    t.string   "text"
    t.string   "from_user"
    t.integer  "keyword_id"
    t.integer  "show_id"
    t.string   "classification"
    t.boolean  "ignore",            :default => false, :null => false
    t.boolean  "confirmed",         :default => false, :null => false
    t.text     "raw"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tweets", ["classification"], :name => "index_tweets_on_classification"
  add_index "tweets", ["confirmed"], :name => "index_tweets_on_confirmed"
  add_index "tweets", ["from_user_id"], :name => "index_tweets_on_from_user_id"
  add_index "tweets", ["ignore"], :name => "index_tweets_on_ignore"
  add_index "tweets", ["keyword_id"], :name => "index_tweets_on_keyword_id"
  add_index "tweets", ["show_id"], :name => "index_tweets_on_show_id"
  add_index "tweets", ["tweet_id"], :name => "index_tweets_on_tweet_id"

  create_table "users", :force => true do |t|
    t.string   "email",                               :default => "",    :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "",    :null => false
    t.string   "password_salt",                       :default => "",    :null => false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin",                               :default => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
