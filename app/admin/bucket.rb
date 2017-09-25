ActiveAdmin.register Bucket do
  config.batch_actions = false

  collection_action :empty, method: :get do
    Bucket.delete_all

    redirect_to collection_path, notice: "Reset done."
  end

  actions :index

  action_item only: :index do
    link_to 'Empty bucket', '/buckets/empty', data: {confirm: 'Are you sure?'}
  end

  index do
    column :id
    column :track do |bucket|
      track = bucket.track
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
    column :duration do |bucket|
      Time.at(bucket.track.duration).utc.strftime("%M:%S") if bucket.track.duration
    end
    column :last_from_artist do |item|
      div do
        before = Playlist.joins("INNER JOIN tracks ON tracks.id = playlists.track_id").where(is_aired: true).where("tracks.artist = ?", item.track.artist).where.not(aired_at: nil).order("playlists.id DESC").first
        unless before.blank?
          track_interval = Playlist.where("id > ?", before.id).count
          div "#{track_interval} track#{track_interval > 1 ? 's' : ''} before"
          div DateLib.humanize(Time.now - before.aired_at)
        end
      end
    end
    column :tag do |item|
      status_tag item.tag.name if item.tag
    end
    column :created do |item|
      time_ago(item.created_at)
    end
    actions
  end




end
