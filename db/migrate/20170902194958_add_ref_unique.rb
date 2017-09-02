class AddRefUnique < ActiveRecord::Migration[5.1]
  def change
    remove_index :tracks, [:ref_external_source]
    add_index :tracks, [:ref_external_source], unique: true, name: "ref_external_source"
  end
end
