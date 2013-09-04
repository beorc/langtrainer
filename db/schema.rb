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

ActiveRecord::Schema.define(:version => 20130904145719) do

  create_table "categories", :force => true do |t|
    t.string   "title"
    t.boolean  "state",      :default => true
    t.integer  "position",   :default => 0
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.string   "slug"
  end

  add_index "categories", ["slug"], :name => "index_categories_on_slug", :unique => true

  create_table "courses", :force => true do |t|
    t.string   "slug"
    t.string   "title"
    t.text     "description"
    t.integer  "user_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "courses", ["slug", "user_id"], :name => "index_courses_on_slug_and_user_id", :unique => true
  add_index "courses", ["title", "user_id"], :name => "index_courses_on_title_and_user_id", :unique => true

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "email_confirmations", :force => true do |t|
    t.integer  "user_id"
    t.string   "new_email"
    t.string   "token"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "email_confirmations", ["new_email"], :name => "index_email_confirmations_on_new_email"
  add_index "email_confirmations", ["token"], :name => "index_email_confirmations_on_token", :unique => true
  add_index "email_confirmations", ["user_id"], :name => "index_email_confirmations_on_user_id"

  create_table "exercises", :force => true do |t|
    t.string   "title"
    t.string   "slug"
    t.integer  "user_id"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.boolean  "shuffled",   :default => true
    t.integer  "course_id"
  end

  add_index "exercises", ["slug"], :name => "index_exercises_on_slug", :unique => true
  add_index "exercises", ["user_id"], :name => "index_exercises_on_user_id"

  create_table "feedbacks", :force => true do |t|
    t.text     "message"
    t.string   "email"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "feedbacks", ["user_id"], :name => "index_feedbacks_on_user_id"

  create_table "forums", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.boolean  "state",        :default => true
    t.integer  "topics_count", :default => 0
    t.integer  "posts_count",  :default => 0
    t.integer  "position",     :default => 0
    t.integer  "category_id"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.string   "language"
    t.string   "slug"
  end

  add_index "forums", ["slug"], :name => "index_forums_on_slug", :unique => true

  create_table "posts", :force => true do |t|
    t.text     "body"
    t.integer  "forum_id"
    t.integer  "topic_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "roles", ["name", "resource_type", "resource_id"], :name => "index_roles_on_name_and_resource_type_and_resource_id"
  add_index "roles", ["name"], :name => "index_roles_on_name"

  create_table "sentences", :force => true do |t|
    t.integer  "user_id"
    t.integer  "exercise_id"
    t.boolean  "atom",        :default => false
    t.integer  "sentence_id"
    t.string   "type"
    t.string   "en"
    t.string   "ru"
    t.integer  "position"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.string   "de"
    t.string   "es"
  end

  add_index "sentences", ["atom"], :name => "index_sentences_on_atom"
  add_index "sentences", ["exercise_id"], :name => "index_sentences_on_exercise_id"
  add_index "sentences", ["position"], :name => "index_sentences_on_position"
  add_index "sentences", ["sentence_id"], :name => "index_sentences_on_sentence_id"
  add_index "sentences", ["user_id", "exercise_id"], :name => "index_sentences_on_user_id_and_exercise_id"
  add_index "sentences", ["user_id", "sentence_id"], :name => "index_sentences_on_user_id_and_sentence_id"
  add_index "sentences", ["user_id"], :name => "index_sentences_on_user_id"

  create_table "topics", :force => true do |t|
    t.string   "title"
    t.integer  "hits",        :default => 0
    t.boolean  "sticky",      :default => false
    t.boolean  "locked",      :default => false
    t.integer  "posts_count"
    t.integer  "forum_id"
    t.integer  "user_id"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.string   "slug"
  end

  add_index "topics", ["slug"], :name => "index_topics_on_slug", :unique => true

  create_table "user_providers", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.string   "provider",   :null => false
    t.string   "uid",        :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "username"
    t.integer  "language_id"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.string   "authentication_token"
    t.integer  "topics_count",         :default => 0
    t.integer  "posts_count",          :default => 0
    t.integer  "en_counter",           :default => 0
    t.integer  "ru_counter",           :default => 0
    t.integer  "de_counter",           :default => 0
    t.string   "nickname"
    t.integer  "es_counter",           :default => 0
  end

  add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["nickname"], :name => "index_users_on_nickname", :unique => true
  add_index "users", ["username"], :name => "index_users_on_username"

  create_table "users_roles", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], :name => "index_users_roles_on_user_id_and_role_id"

end
