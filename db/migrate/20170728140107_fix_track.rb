class FixTrack < ActiveRecord::Migration[5.1]
  def change
    rename_column :tracks, :length, :duration
    remove_column :tracks, :bitrate_type_of
    add_column :tracks, :ref, :string, limit: 40
    add_index :tracks, [:ref], unique: true, name: "idx_ref"
  end
end
