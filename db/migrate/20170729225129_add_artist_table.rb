class AddArtistTable < ActiveRecord::Migration[5.1]
  def change
    create_table "artists", id: :bigint, auto_increment: true, default: nil, force: :cascade, options: "ENGINE=InnoDB ROW_FORMAT=dynamic DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.string "name"
      t.timestamps
      t.index ["name"], name: "name", using: :btree, unique: true
    end
  end
end
