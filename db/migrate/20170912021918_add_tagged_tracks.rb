# Encoding: UTF-8
class AddTaggedTracks < ActiveRecord::Migration[5.1]
  def change
    Tag.create!(name: 'Rap français')
    Tag.create!(name: 'Rap US')

    tag = Tag.find_by(name: 'Rap français')

    Track.all.each do |track|
      TaggedTrack.create!(tag_id: tag.id, track_id: track.id)
    end
  end
end
