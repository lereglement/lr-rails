class AddYoutube < ActiveRecord::Migration[5.1]
  def change
    add_column :tracks, :title_external_source, :string
    add_column :tracks, :ref_external_source, :string, limit: 30
    add_index :tracks, [:ref_external_source], unique: true, name: "ref_external_source"
  end
end
