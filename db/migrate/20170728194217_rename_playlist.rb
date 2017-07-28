class RenamePlaylist < ActiveRecord::Migration[5.1]
  def change
    rename_table :playlist, :playlists
  end
end
