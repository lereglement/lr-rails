class AddPlaylistCol < ActiveRecord::Migration[5.1]
  def change
    add_column :playlists, :type_of, :string, limit: 40
  end
end
