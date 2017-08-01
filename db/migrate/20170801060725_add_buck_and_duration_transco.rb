class AddBuckAndDurationTransco < ActiveRecord::Migration[5.1]
  def change
    add_column :tracks, :duration_converted, :integer
    change_column_default :tracks, :aired_count, 0

    create_table "buckets", id: :bigint, auto_increment: true, default: nil, force: :cascade, options: "ENGINE=InnoDB ROW_FORMAT=dynamic DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.integer "track_id"
      t.timestamps
      t.index ["track_id"], name: "track_id", using: :btree
    end

  end
end
