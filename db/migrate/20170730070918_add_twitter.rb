class AddTwitter < ActiveRecord::Migration[5.1]
  def change
    add_attachment :artists, :picture
    add_column :artists, :twitter, :string
  end
end
