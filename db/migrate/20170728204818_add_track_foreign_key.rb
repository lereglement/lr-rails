class AddTrackForeignKey < ActiveRecord::Migration[5.1]
  def change
    add_foreign_key "playlists", "tracks", name: "fk_playlist_track"
  end
end
