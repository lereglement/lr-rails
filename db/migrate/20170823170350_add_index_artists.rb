class AddIndexArtists < ActiveRecord::Migration[5.1]
  def change
    change_column :tracks, :artist, :string, limit: 100
    change_column :artists, :name, :string, limit: 100
    change_column :buckets, :artist, :string, limit: 100

    add_index :tracks, [:artist], name: "artist"
    add_index :artists, [:name], name: "artist"
    add_index :buckets, [:artist], name: "artist"
  end
end
