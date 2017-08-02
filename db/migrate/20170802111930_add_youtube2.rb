class AddYoutube2 < ActiveRecord::Migration[5.1]
  def change
    add_column :tracks, :origin_external_source, :string, limit: 40
  end
end
