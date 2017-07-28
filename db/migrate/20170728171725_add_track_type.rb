class AddTrackType < ActiveRecord::Migration[5.1]
  def change
    add_column :tracks, :type_of, :string, limit: 40
    add_column :tracks, :last_aired_at, :datetime
    add_column :tracks, :aired_count, :integer
  end
end
