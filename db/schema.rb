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

ActiveRecord::Schema.define(version: 20170522170021) do

  create_table "active_admin_comments", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
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

  create_table "admin_users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
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

  create_table "cards", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.string "ref", limit: 40
    t.bigint "medium_id"
    t.bigint "user_id", null: false
    t.bigint "user_id_target", null: false
    t.boolean "is_liked", default: false, null: false
    t.boolean "is_disliked", default: false, null: false
    t.boolean "is_seen", default: false, null: false
    t.datetime "seen_at"
    t.string "source", limit: 20
    t.string "version", limit: 20
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["medium_id"], name: "medium_id"
    t.index ["ref"], name: "ref", unique: true
    t.index ["source"], name: "source"
    t.index ["user_id", "user_id_target", "is_liked"], name: "user_id__user_id_target__liked"
    t.index ["user_id"], name: "user_id"
    t.index ["user_id_target", "user_id", "is_liked"], name: "user_id_target__user_id__liked"
    t.index ["user_id_target"], name: "user_id_target"
    t.index ["version"], name: "version"
  end

  create_table "connections", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.string "user_ids", limit: 50
    t.bigint "user_id"
    t.bigint "user_id_target"
    t.integer "like_count", default: 0, null: false
    t.integer "dislike_count", default: 0, null: false
    t.bigint "discussion_id"
    t.boolean "is_visited", default: false, null: false
    t.string "state", limit: 40, default: "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["discussion_id"], name: "discussion_id"
    t.index ["state"], name: "state"
    t.index ["user_id"], name: "user_id"
    t.index ["user_id_target"], name: "user_id_target"
    t.index ["user_ids"], name: "user_ids"
  end

  create_table "copywritings", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.string "ref", limit: 40, null: false
    t.string "content", limit: 1000
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ref"], name: "ref", unique: true
  end

  create_table "discussion_messages", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.bigint "discussion_id", null: false
    t.bigint "user_id", null: false
    t.bigint "user_id_target", null: false
    t.text "message"
    t.boolean "is_read", default: false, null: false
    t.bigint "medium_id"
    t.string "type_of", limit: 40, default: "message"
    t.string "state", limit: 40, default: "published"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["discussion_id"], name: "discussion_id"
    t.index ["medium_id"], name: "medium_id"
    t.index ["state"], name: "state"
    t.index ["type_of"], name: "type_of"
    t.index ["user_id"], name: "user_id"
    t.index ["user_id_target"], name: "user_id_target"
  end

  create_table "discussions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.string "ref", limit: 40
    t.string "user_ids", limit: 50
    t.bigint "user_id_1"
    t.bigint "user_id_2"
    t.boolean "is_unblur", default: false, null: false
    t.boolean "is_unblur_1", default: false, null: false
    t.boolean "is_unblur_2", default: false, null: false
    t.boolean "has_accepted", default: false, null: false
    t.boolean "has_accepted_1", default: false, null: false
    t.boolean "has_accepted_2", default: false, null: false
    t.datetime "reviewed_at"
    t.integer "user_1_unread_count", default: 0, null: false, unsigned: true
    t.integer "user_2_unread_count", default: 0, null: false, unsigned: true
    t.datetime "last_message_at"
    t.datetime "user_1_last_visit_at"
    t.datetime "user_2_last_visit_at"
    t.integer "message_count", default: 0, null: false, unsigned: true
    t.string "state", limit: 40, default: "published"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["has_accepted"], name: "has_accepted"
    t.index ["ref"], name: "ref"
    t.index ["state"], name: "state"
    t.index ["user_id_1"], name: "user_id_1"
    t.index ["user_id_2"], name: "user_id_2"
    t.index ["user_ids"], name: "user_ids", unique: true
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

  create_table "flags", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.bigint "user_id", null: false
    t.string "user_ref", limit: 40
    t.string "medium_ref", limit: 40
    t.string "discussion_ref", limit: 40
    t.string "type_of", limit: 40
    t.string "state", limit: 40, default: "pending"
    t.bigint "user_id_admin"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["discussion_ref"], name: "discussion_ref"
    t.index ["medium_ref"], name: "medium_ref"
    t.index ["state"], name: "state"
    t.index ["type_of"], name: "type_of"
    t.index ["user_id"], name: "user_id"
    t.index ["user_id_admin"], name: "user_id_admin"
    t.index ["user_ref"], name: "user_ref"
  end

  create_table "instagram_users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.bigint "instagram_ref"
    t.string "username"
    t.string "full_name"
    t.string "profile_picture"
    t.string "access_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["instagram_ref"], name: "instagram_ref", unique: true
  end

  create_table "log_users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.bigint "user_id", null: false
    t.string "ip"
    t.string "device_unique_id"
    t.string "user_agent"
    t.decimal "latitude", precision: 10, scale: 8
    t.decimal "longitude", precision: 11, scale: 8
    t.string "device_manufacturer"
    t.string "device_brand"
    t.string "device_model"
    t.string "device_id"
    t.string "device_name"
    t.string "device_local"
    t.string "device_country"
    t.string "system_name"
    t.string "system_version"
    t.string "bundle_id"
    t.string "build_number"
    t.string "app_version"
    t.string "app_version_readable"
    t.string "app_instance_id"
    t.string "timezone"
    t.boolean "is_emulator"
    t.boolean "is_tablet"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["app_version_readable"], name: "app_version_readable"
    t.index ["device_brand"], name: "device_brand"
    t.index ["device_model"], name: "device_model"
    t.index ["is_emulator"], name: "is_emulator"
    t.index ["system_name"], name: "system_name"
    t.index ["user_id"], name: "user_id"
  end

  create_table "mails", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.string "from_email"
    t.string "from_name"
    t.string "to_email"
    t.string "to_name"
    t.string "subject"
    t.text "html"
    t.datetime "sent_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "media", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.string "ref", limit: 40
    t.string "ref_clean", limit: 40
    t.string "ref_blurred", limit: 40
    t.bigint "user_id", null: false
    t.string "type_of", limit: 40
    t.string "label", limit: 500
    t.string "state", limit: 40
    t.integer "position"
    t.string "item_file_name"
    t.integer "item_file_size"
    t.string "item_content_type"
    t.string "item_updated_at"
    t.integer "height"
    t.integer "width"
    t.boolean "has_issue", default: false, null: false
    t.string "color", limit: 10
    t.datetime "reviewed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ref"], name: "ref", unique: true
    t.index ["ref_blurred"], name: "ref_blurred", unique: true
    t.index ["ref_clean"], name: "ref_clean", unique: true
    t.index ["state"], name: "state"
    t.index ["type_of"], name: "type_of"
    t.index ["user_id"], name: "user_id"
  end

  create_table "notifications", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.bigint "user_id", null: false
    t.bigint "user_id_target"
    t.boolean "is_seen", default: false, null: false
    t.boolean "is_sent", default: false, null: false
    t.string "content"
    t.string "type_onboarded", limit: 40
    t.string "type_of", limit: 40
    t.string "batch_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["type_of"], name: "type_of"
    t.index ["user_id", "is_seen"], name: "user_seen"
    t.index ["user_id"], name: "user_id"
    t.index ["user_id_target"], name: "user_id_target"
  end

  create_table "predictions", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.bigint "medium_id", null: false
    t.string "service"
    t.string "value"
    t.decimal "probability", precision: 9, scale: 8
    t.integer "x_min"
    t.integer "x_max"
    t.integer "y_min"
    t.integer "y_max"
    t.boolean "is_active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["medium_id"], name: "medium_id"
    t.index ["service"], name: "service"
    t.index ["value"], name: "value"
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.string "ref", limit: 40
    t.bigint "facebook_user_id"
    t.bigint "instagram_user_id"
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.integer "age"
    t.integer "age_min", default: 18, null: false
    t.integer "age_max", default: 60, null: false
    t.string "description", limit: 2000
    t.string "gender", limit: 40
    t.string "gender_target", limit: 40
    t.string "theme"
    t.integer "range", default: 15, null: false
    t.decimal "latitude", precision: 10, scale: 8
    t.decimal "longitude", precision: 11, scale: 8
    t.boolean "is_notification_match", default: true, null: false
    t.boolean "is_notification_message", default: true, null: false
    t.boolean "is_notification_selection", default: true, null: false
    t.boolean "is_email_match", default: false, null: false
    t.boolean "is_email_message", default: false, null: false
    t.boolean "is_email_selection", default: false, null: false
    t.string "state", limit: 40, default: "pending"
    t.boolean "is_onboarded", default: false, null: false
    t.boolean "is_complete", default: false, null: false
    t.boolean "is_admin", default: false, null: false
    t.integer "portrait_count", default: 0, null: false
    t.integer "picture_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["age"], name: "age"
    t.index ["facebook_user_id"], name: "facebook_user_id", unique: true
    t.index ["instagram_user_id"], name: "instagram_user_id", unique: true
    t.index ["is_complete"], name: "is_complete"
    t.index ["ref"], name: "ref", unique: true
    t.index ["state"], name: "state"
  end

  add_foreign_key "cards", "media", name: "fk_card_medium"
  add_foreign_key "cards", "users", column: "user_id_target", name: "fk_card_user_target"
  add_foreign_key "cards", "users", name: "fk_card_user"
  add_foreign_key "connections", "discussions", name: "fk_connection_discussion"
  add_foreign_key "connections", "users", column: "user_id_target", name: "fk_connection_users_target"
  add_foreign_key "connections", "users", name: "fk_connection_user"
  add_foreign_key "discussion_messages", "discussions", name: "fk_discussion_discussion_message"
  add_foreign_key "discussion_messages", "media", name: "fk_discussion_message_medium"
  add_foreign_key "discussion_messages", "users", column: "user_id_target", name: "fk_discussion_users_target"
  add_foreign_key "discussion_messages", "users", name: "fk_discussion_users"
  add_foreign_key "discussions", "users", column: "user_id_1", name: "fk_discussion_user_1"
  add_foreign_key "discussions", "users", column: "user_id_2", name: "fk_discussion_user_2"
  add_foreign_key "flags", "discussions", column: "discussion_ref", primary_key: "ref", name: "fk_flag_discussion_ref"
  add_foreign_key "flags", "media", column: "medium_ref", primary_key: "ref", name: "fk_flag_medium_ref"
  add_foreign_key "flags", "users", column: "user_id_admin", name: "fk_flag_user_admin"
  add_foreign_key "flags", "users", column: "user_ref", primary_key: "ref", name: "fk_flag_user_ref"
  add_foreign_key "flags", "users", name: "fk_flag_user"
  add_foreign_key "log_users", "users", name: "fk_log_user_user"
  add_foreign_key "media", "users", name: "fk_medium_user"
  add_foreign_key "notifications", "users", column: "user_id_target", name: "fk_notification_user_target"
  add_foreign_key "notifications", "users", name: "fk_notification_user"
  add_foreign_key "predictions", "media", name: "fk_prediction_media"
  add_foreign_key "users", "facebook_users", name: "fk_user_facebook_user"
  add_foreign_key "users", "instagram_users", name: "fk_user_instagram_user"
end
