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

ActiveRecord::Schema.define(version: 20170902194958) do

  create_table "active_admin_comments", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_id", null: false
    t.string "resource_type", null: false
    t.string "author_type"
    t.integer "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "admin_users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "artists", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.string "name", limit: 100
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "picture_file_name"
    t.string "picture_content_type"
    t.integer "picture_file_size"
    t.datetime "picture_updated_at"
    t.string "twitter"
    t.string "type_of", limit: 40
    t.index ["name"], name: "artist"
    t.index ["type_of"], name: "type_of"
  end

  create_table "buckets", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.bigint "track_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "artist", limit: 100
    t.index ["artist"], name: "artist"
    t.index ["track_id"], name: "track_id"
  end

  create_table "facebook_users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.bigint "facebook_ref"
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "gender"
    t.date "birthday"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["facebook_ref"], name: "facebook_ref", unique: true
  end

  create_table "playlists", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.bigint "track_id"
    t.boolean "is_aired", default: false, null: false
    t.datetime "aired_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type_of", limit: 40
    t.index ["is_aired"], name: "is_aired"
    t.index ["track_id"], name: "fk_playlist_track"
    t.index ["type_of", "id"], name: "type_of_id"
  end

  create_table "tracks", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.string "artist", limit: 100
    t.string "title"
    t.integer "duration"
    t.integer "bitrate"
    t.boolean "is_converted", default: false, null: false
    t.string "state", limit: 40, default: "pending"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "track_file_name"
    t.string "track_content_type"
    t.integer "track_file_size"
    t.datetime "track_updated_at"
    t.string "ref", limit: 40
    t.string "type_of", limit: 40
    t.datetime "last_aired_at"
    t.integer "aired_count", default: 0
    t.string "cover_file_name"
    t.string "cover_content_type"
    t.integer "cover_file_size"
    t.datetime "cover_updated_at"
    t.string "external_source"
    t.integer "duration_converted"
    t.string "title_external_source"
    t.string "ref_external_source", limit: 180
    t.string "origin_external_source", limit: 40
    t.string "error_logs"
    t.index ["artist"], name: "artist"
    t.index ["bitrate"], name: "bitrate"
    t.index ["ref"], name: "idx_ref", unique: true
    t.index ["ref_external_source"], name: "ref_external_source", unique: true
    t.index ["state"], name: "state"
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.string "ref", limit: 40
    t.bigint "facebook_user_id"
    t.string "first_name"
    t.string "last_name"
    t.string "username"
    t.string "email"
    t.date "birthday"
    t.string "gender", limit: 40
    t.string "state", limit: 40, default: "pending"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["facebook_user_id"], name: "facebook_user_id", unique: true
    t.index ["ref"], name: "ref", unique: true
    t.index ["state"], name: "state"
  end

  add_foreign_key "buckets", "tracks", name: "fk_bucket_track"
  add_foreign_key "playlists", "tracks", name: "fk_playlist_track"
end
