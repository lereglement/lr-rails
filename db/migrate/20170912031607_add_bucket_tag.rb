class AddBucketTag < ActiveRecord::Migration[5.1]
  def change
    add_column :buckets, :tag_id, :bigint

    add_index :buckets, [:tag_id]
    add_foreign_key :buckets, :tags, name: "fk_bucket_tag"


  end
end
