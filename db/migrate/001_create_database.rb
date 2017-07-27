class CreateDatabase < ActiveRecord::Migration[5.0]
  def self.up
    create_table "tracks", id: :bigint, auto_increment: true, default: nil, force: :cascade, options: "ENGINE=InnoDB ROW_FORMAT=dynamic DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.string "artist"
      t.string "title"
      t.integer "length"
      t.integer "year"
      t.integer "bitrate"
      t.string "bitrate_type_of"
      t.boolean "is_converted", default: false, null: false
      t.string "state", limit: 40, default: 'active'
      t.timestamps
      t.index ["year"], name: "year", using: :btree
      t.index ["bitrate"], name: "bitrate", using: :btree
      t.index ["bitrate_type_of"], name: "bitrate_type_of", using: :btree
      t.index ["state"], name: "state", using: :btree
    end

    create_table "playlist", id: :bigint, auto_increment: true, default: nil, force: :cascade, options: "ENGINE=InnoDB ROW_FORMAT=dynamic DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.bigint "track_id"
      t.boolean "is_aired", default: false, null: false
      t.datetime "aired_at"
      t.timestamps
      t.index ["is_aired"], name: "is_aired", using: :btree
    end

  end
end
