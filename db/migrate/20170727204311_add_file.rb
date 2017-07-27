class AddFile < ActiveRecord::Migration[5.1]
  def change
    add_attachment :tracks, :track
  end
end
