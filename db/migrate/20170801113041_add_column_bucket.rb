class AddColumnBucket < ActiveRecord::Migration[5.1]
  def change
    add_column :buckets, :artist, :string
  end
end
