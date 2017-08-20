ActiveAdmin.register Playlist do
  config.batch_actions = false

  collection_action :now, method: :get do
    id = params[:id]
    track = Track.where(state: :active, is_converted: true).find(id)

    unless track.blank?
      Playlist.create({
        track_id: track.id,
        type_of: track.type_of,
      })
    end

    redirect_to collection_path, notice: "Inserted in playlist."
  end

  actions :index

  action_item do
    link_to 'Double-R Live', 'https://www.youtube.com/lereglement/live'
  end

  index do
    column :id
    column :aired_at do |item|
      time_ago(item.aired_at)
    end
    column :type do |item|
      status_tag item.type_of
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
    column :aired_count do |item|
      track = item.track
      track.aired_count
    end
    column :gap do |track|
      before = Playlist.where("id < ?", track.id).order(id: :desc).first
      unless before.blank? || track.type_of == "jingle"
        gap = (track.created_at - before.created_at).to_i
        if gap < 3
          b style: "color:red; font-weight: bold" do
            span "#{gap} s."
          end
        else
          span "#{gap} s."
        end
      end
    end
    column :last_aired do |item|
      div do
        before = Playlist.where(track_id: item.track_id, is_aired: true).where.not(aired_at: nil).where("id < ?", item.id).order(id: :desc).first
        unless before.blank?
          div DateLib.humanize(item.aired_at - before.aired_at) if item.aired_at
        end
      end
    end
    column :created do |item|
      time_ago(item.created_at)
    end
    actions
  end



end
