class AddTags < ActiveRecord::Migration[5.1]
  def change
    create_table "tags", id: :bigint, auto_increment: true, default: nil, force: :cascade, options: "ENGINE=InnoDB ROW_FORMAT=dynamic DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.string "name", null: false
      t.timestamps
    end
    create_table "tagged_tracks", id: :bigint, auto_increment: true, default: nil, force: :cascade, options: "ENGINE=InnoDB ROW_FORMAT=dynamic DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.bigint "track_id", null: false
      t.bigint "tag_id", null: false
      t.timestamps
    end
    add_index :tagged_tracks, [:tag_id]
    add_index :tagged_tracks, [:track_id, :tag_id], unique: true
    add_foreign_key :tagged_tracks, :tracks, name: "fk_tagged_track"
    add_foreign_key :tagged_tracks, :tags, name: "fk_tagged_tag"
  end
end
