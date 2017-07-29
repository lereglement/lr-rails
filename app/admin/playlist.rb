ActiveAdmin.register Playlist do
  config.batch_actions = false

  actions :index, :destroy

  scope("Next", default: true) { |scope|
    scope.where(is_aired: false).reorder(:id)
  }
  scope("Previous") { |scope|
    scope.where(is_aired: true).reorder(id: :desc)
  }

  index do
    column :id
    column :aired_at do |item|
      time_ago(item.aired_at)
    end
    column :track do |item|
      track = item.track
      div style: "display:flex; align-items: center;" do
        div auto_link(track, image_tag(track.cover.url(:xsmall), size: 50, style: "margin-right: 10px;"))
        div do
          div b track.artist if track.artist
          div do
            track_title = !track.title.blank? ? track.title : track.track_file_name
            auto_link track, track_title
          end
        end
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
