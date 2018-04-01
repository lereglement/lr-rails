class AddIndexesToTracksAndPlaylists < ActiveRecord::Migration[5.1]
  def change
    add_index :tracks, :type_of
    add_index :playlists, :track_id
  end
end
