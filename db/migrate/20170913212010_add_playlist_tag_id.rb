class AddPlaylistTagId < ActiveRecord::Migration[5.1]
  def change
    add_column :playlists, :tag_id, :bigint

    add_index :playlists, [:tag_id]
    add_foreign_key :playlists, :tags, name: "fk_playlist_tag"

    Bucket.where(tag_id: nil).update_all(tag_id: 1)
  end
end
