class AddIndexTypeOfBucket < ActiveRecord::Migration[5.1]
  def change
    add_index :playlists, [:type_of, :id], name: "type_of_id"
  end
end
