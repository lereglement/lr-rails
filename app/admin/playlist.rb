ActiveAdmin.register Playlist do

  actions :index, :destroy

  index do
    column :id
    column :aired_at do |item|
      time_ago(item.aired_at)
    end
    column :cover do |item|
      auto_link(item.track, image_tag(item.track.cover.url(:xsmall), size: 50))
    end
    column :track do |item|
      div b item.track.artist if item.track.artist
      div do
        track_title = !item.track.title.blank? ? item.track.title : item.track.track_file_name
        auto_link item.track, track_title
      end
    end
    column :player do |item|
      div audio_tag(item.track.track.url, controls: true)
    end
    column :created do |item|
      time_ago(item.created_at)
    end
    actions
  end



end
