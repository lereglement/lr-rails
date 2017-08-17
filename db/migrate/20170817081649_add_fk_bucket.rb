class AddFkBucket < ActiveRecord::Migration[5.1]
  def change
    change_column :buckets, :track_id, :bigint
    add_foreign_key "buckets", "tracks", name: "fk_bucket_track"
  end
end
