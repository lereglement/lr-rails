ActiveAdmin.register Track do
  config.batch_actions = false

  collection_action :reset, method: :get do
    Track.where(is_converted: true).update(is_converted: false)

    redirect_to collection_path, notice: "Reset done."
  end

  actions :all

  permit_params :artist,
    :title,
    :bitrate,
    :is_converted,
    :track,
    :cover,
    :state,
    :type_of,
    :external_source

  filter :title_or_artist_contains
  filter :state, as: :select, collection: Track.get_states.map { |value| value }
  filter :type_of, as: :select, collection: Track.get_types.map { |value| value }
  filter :is_converted
  filter :bitrate
  filter :created_at
  filter :updated_at

  action_item(:index) do
    link_to 'Reset Transco', '/tracks/reset', data: {confirm: 'Are you sure?'}
  end

  scope("Active", default: true) { |scope| scope.where(state: :active) }
  scope("Pending") { |scope| scope.where(state: :pending) }
  scope("Expired") { |scope| scope.where(state: :expired) }
  scope("Striked") { |scope| scope.where(state: :striked) }
  scope("Rejected") { |scope| scope.where(state: :rejected) }
  scope("Wip") { |scope| scope.where(state: :wip) }
  scope("Suggested") { |scope| scope.where(state: :suggested) }
  scope("Not converted") { |scope| scope.where(state: [:active, :pending, :expired]).where(is_converted: false) }
  scope("Issues") { |scope| scope.where(" duration <> duration_converted ").where(is_converted: true).reorder(" ABS(duration - duration_converted) DESC") }
  scope("All") { |scope| scope }

  index do
    column :id
    column :track do |track|
      div style: "display:flex; align-items: center;" do
        div auto_link(track, image_tag(track.cover.url(:xsmall), size: 50, style: "margin-right: 10px;"))
        div do
          artist = Artist.find_by(name: track.artist)
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
    column :tags do |track|
      span status_tag track.state
      span status_tag track.type_of
      span status_tag "Raw" if track.is_converted == false
    end
    column :stats do |track|
      div "Aired: #{track.aired_count}"
      div "Diff: #{(track.duration - track.duration_converted).abs} sec" if track.duration && track.duration_converted && (track.duration - track.duration_converted).abs > 0
    end
    column :last_aired do |track|
      div DateLib.humanize(Time.now - track.last_aired_at) if track.last_aired_at
      div link_to "Play next", "/playlists/now/?id=#{track.id}", class: "play-next", data: {confirm: 'Are you sure to play it next?'} if track.state.to_sym == :active && track.is_converted == true
    end
    column :created do |track|
      time_ago(track.created_at)
    end
    actions
  end

  show title: proc{|track| "#{track.title}" } do
    attributes_table do
      row :artist do |track|
        auto_link(Artist.find_by(name: track.artist), track.artist)
      end
      row :title
      row :duration do |track|
        Time.at(track.duration).utc.strftime("%M:%S")
      end if resource.duration
      row :duration_converted do |track|
        Time.at(track.duration_converted).utc.strftime("%M:%S")
      end if resource.duration_converted
      row :listen do |track|
        div audio_tag(track.track.url, controls: true)
      end
      row :converted do |track|
        div audio_tag("//#{Rails.application.secrets.s3_host_name}/#{Rails.application.secrets.s3_bucket}#{TrackLib.transcoded_file(track)}", controls: true)
      end if resource.is_converted == true && !resource.track_file_name.blank?
      row :file do |track|
        div track.track_file_name
        div do
          span MathLib.format_size(track.track_file_size) if track.track_file_size
          span track.bitrate if track.bitrate
        end
      end unless track.track.blank?
      row :tags do |track|
        span status_tag track.state
        span status_tag track.type_of
        span status_tag "Raw" if track.is_converted == false
      end
      row :ref
    end
    active_admin_comments
  end

  form do |f|
    inputs 'Details' do
      input :artist, as: :autocomplete, url: autocomplete_artist_name_artists_path
      input :title
      input :state, as: :select, collection: Track.get_states.map { |value| value }, include_blank: false
      input :type_of, as: :select, collection: Track.get_types.map { |value| value }, include_blank: false
      input :is_converted
    end
    div style: "display: flex; align-items: stretch; " do
      div style: "flex-grow: 1" do
        inputs 'Cover' do
          input :cover, as: :file, input_html: { accept:".jpeg,.jpg,.png,.gif" }
          li style: "background-image: url(#{resource.cover.url(:large)}); width: 150px; height: 150px; background-size: cover; margin-left: 20%; margin-top: -170px;"
        end
      end
      div style: "flex-grow: 1" do
        inputs 'File' do
          input :track, as: :file, input_html: { accept:".mp3,.ogg" }
          track_image = resource.track_file_name ? "/missing/track_on.svg" : "/missing/track_off.svg"
          li style: "background-image: url(#{track_image}); width: 150px; height: 150px; background-size: cover; margin-left: 20%; margin-top: -170px;"
          li class: "form_content_margin" do
            "#{resource.track_file_name}"
          end
        end
      end
    end
    inputs 'External' do
      input :external_source
      li class: "form_content_margin" do
        div resource.ref_external_source
        div resource.origin_external_source
      end
    end
    actions
  end

  sidebar "Details", only: :show do
    div do
      div image_tag(resource.cover.url(:large), size: 250)
      div b "Created: #{time_ago(resource.created_at)}"
      div b "Updated: #{time_ago(resource.updated_at)}"
      div b "Uploaded: #{time_ago(resource.track_updated_at)}" if resource.track_updated_at
      div "Bitrate: #{resource.bitrate}" if resource.bitrate
      div "Type: #{resource.track_content_type}" if resource.track_content_type

    end
  end

end
