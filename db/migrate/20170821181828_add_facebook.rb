class AddFacebook < ActiveRecord::Migration[5.1]
  def change
    create_table "facebook_users", id: :bigint, auto_increment: true, default: nil, force: :cascade, options: "ENGINE=InnoDB ROW_FORMAT=dynamic DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.bigint "facebook_ref"
      t.string "first_name"
      t.string "last_name"
      t.string "email"
      t.string "gender"
      t.date "birthday"
      t.timestamps
      t.index ["facebook_ref"], unique: true, name: "facebook_ref", using: :btree
    end

    create_table "users", id: :bigint, auto_increment: true, default: nil, force: :cascade, options: "ENGINE=InnoDB ROW_FORMAT=dynamic DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.string "ref", limit: 40
      t.bigint "facebook_user_id"
      t.string "first_name"
      t.string "last_name"
      t.string "username"
      t.string "email"
      t.date "birthday"
      t.string "gender", limit: 40
      t.string "state", limit: 40, default: 'pending'
      t.timestamps
      t.index ["facebook_user_id"], name: "facebook_user_id", unique: true, using: :btree
      t.index ["ref"], name: "ref", unique: true, using: :btree
      t.index ["state"], name: "state", using: :btree
    end


  end
end
