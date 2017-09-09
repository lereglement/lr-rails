class Settings < ActiveRecord::Migration[5.1]
  def change
    create_table :settings, id: :bigint, auto_increment: true, default: nil, force: :cascade, options: "ENGINE=InnoDB ROW_FORMAT=dynamic DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.string "name"
      t.string "value"
      t.timestamps
      t.index ["name"], name: "name", using: :btree
    end
    Setting.create!(name: 'previous_track', value: 'http://cache.lereglement.sale/previous')
    Setting.create!(name: 'current_track', value: 'http://cache.lereglement.sale/current')
    Setting.create!(name: 'youtube_videos', value: 'http://cache.lereglement.sale/youtube_videos')
    Setting.create!(name: 'stream', value: 'http://streamer01.lereglement.xyz:8000/live')
  end
end
