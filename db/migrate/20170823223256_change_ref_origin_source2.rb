class ChangeRefOriginSource2 < ActiveRecord::Migration[5.1]
  def change
    remove_index :tracks, [:ref_external_source]
    add_index :tracks, [:ref_external_source]
  end
end
