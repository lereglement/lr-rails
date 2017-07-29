class AddFieldTracks < ActiveRecord::Migration[5.1]
  def change
    add_attachment :tracks, :cover
    remove_column :tracks, :year
    add_column :tracks, :external_source, :string
  end
end
