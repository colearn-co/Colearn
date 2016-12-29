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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20161229091229) do


  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ahoy_messages", force: :cascade do |t|
    t.string   "token"
    t.text     "to"
    t.integer  "user_id"
    t.string   "user_type"
    t.string   "mailer"
    t.text     "subject"
    t.datetime "sent_at"
    t.datetime "opened_at"
    t.datetime "clicked_at"
  end

  add_index "ahoy_messages", ["token"], name: "index_ahoy_messages_on_token", using: :btree
  add_index "ahoy_messages", ["user_id", "user_type"], name: "index_ahoy_messages_on_user_id_and_user_type", using: :btree

  create_table "authentications", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "chat_resources", force: :cascade do |t|
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.integer  "chat_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "chats", force: :cascade do |t|
    t.integer  "chatable_id"
    t.string   "chatable_type"
    t.integer  "user_id"
    t.text     "message"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "chats", ["chatable_type", "chatable_id"], name: "index_chats_on_chatable_type_and_chatable_id", using: :btree

  create_table "comments", force: :cascade do |t|
    t.text     "message"
    t.integer  "user_id"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "comments", ["commentable_type", "commentable_id"], name: "index_comments_on_commentable_type_and_commentable_id", using: :btree

  create_table "feedbacks", force: :cascade do |t|
    t.integer  "user_id"
    t.text     "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "invites", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "post_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "status"
    t.text     "message"
    t.integer  "accepting_user_id"
    t.text     "reject_message"
  end

  create_table "posts", force: :cascade do |t|
    t.text     "message"
    t.integer  "user_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "title"
    t.integer  "status"
    t.integer  "publish_status"
  end

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roles_users", id: false, force: :cascade do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roles_users", id: false, force: :cascade do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  add_index "roles_users", ["role_id"], name: "index_roles_users_on_role_id", using: :btree
  add_index "roles_users", ["user_id"], name: "index_roles_users_on_user_id", using: :btree

  create_table "skills", force: :cascade do |t|
    t.string   "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "post_id"
    t.integer  "user_id"
  end

  create_table "suggestions", force: :cascade do |t|
    t.text     "message"
    t.integer  "user_id"
    t.integer  "post_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tags", force: :cascade do |t|
    t.string   "tag"
    t.text     "desc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "unsubscribes", force: :cascade do |t|
    t.string   "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_chat_infos", force: :cascade do |t|
    t.datetime "last_visited"
    t.integer  "user_id"
    t.integer  "post_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "user_chat_infos", ["user_id", "post_id"], name: "index_user_chat_infos_on_user_id_and_post_id", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "name"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "referrer"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "votes", force: :cascade do |t|
    t.integer  "votable_id"
    t.string   "votable_type"
    t.integer  "user_id"
    t.integer  "vote_type"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "votes", ["votable_type", "votable_id"], name: "index_votes_on_votable_type_and_votable_id", using: :btree

end
