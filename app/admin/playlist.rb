ActiveAdmin.register Playlist do
  config.batch_actions = false

  actions :index, :destroy

  scope("Next", default: true) { |scope| scope.where(is_aired: false).reorder(:id) }
  scope("Now & Previous") { |scope| scope.where(is_aired: true).reorder(id: :desc) }

  index do
    column :id
    column :aired_at do |item|
      time_ago(item.aired_at)
    end
    column :track do |item|
      track = item.track
      artist = Artist.find_by(name: track.artist)
      div style: "display:flex; align-items: center;" do
        if !track.cover.blank?
          cover = track.cover.url(:xsmall)
        elsif artist
          cover = artist.picture.url(:xsmall)
        else
          cover = track.cover.url(:xsmall)
        end
        div auto_link(track, image_tag(cover, size: 50, style: "margin-right: 10px;"))
        div do
          if artist
            div b auto_link artist, track.artist
          else
            div b track.artist if track.artist
          end
          div do
            track_title = !track.title.blank? ? track.title : track.track_file_name
            auto_link track, track_title
          end
        end
      end
    end
    column :duration do |item|
      Time.at(item.track.duration).utc.strftime("%M:%S") if item.track.duration
    end
    column :created do |item|
      time_ago(item.created_at)
    end
    actions
  end



end
