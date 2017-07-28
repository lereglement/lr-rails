ActiveAdmin.register Playlist do

  actions :index, :destroy

  index do
    column :id
    column :aired_at
    column :track do |item|
      div b item.track.artist if item.track.artist
      div do
        track_title = !item.track.title.blank? ? "#{item.track.title} #{item.track.year ? '(' + item.track.year.to_s + ')' : ''}" : item.track.item.track_file_name
        auto_link item.track, track_title
      end
    end
    column :player do |item|
      div audio_tag(item.track.track.url, controls: true)
    end
    column :created do |track|
      time_ago(track.created_at)
    end
    actions
  end



end
