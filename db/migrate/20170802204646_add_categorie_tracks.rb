class AddCategorieTracks < ActiveRecord::Migration[5.1]
  def change
    add_column :artists, :type_of, :string, limit: 40
    add_index :artists, [:type_of], name: "type_of"
  end
end
