ActiveAdmin.register Track do

  collection_action :reset, method: :get do
    Track.where(is_converted: true).update(is_converted: false)

    redirect_to collection_path, notice: "Reset done."
  end

  actions :all, :except => [:destroy]

  permit_params :artist,
    :title,
    :duration,
    :bitrate,
    :is_converted,
    :track,
    :cover,
    :state,
    :type_of

  filter :title_or_artist_contains
  filter :state, as: :select, collection: Track.get_states.map { |value| value }
  filter :type_of, as: :select, collection: Track.get_types.map { |value| value }
  filter :is_converted
  filter :bitrate
  filter :created_at
  filter :updated_at

  action_item only: :index do
    link_to 'Reset Transco', '/tracks/reset', data: {confirm: 'Are you sure?'}
  end

  scope("Active", default: true) { |scope| scope.where(state: :active) }
  scope("Pending") { |scope| scope.where(state: :pending) }
  scope("Expired") { |scope| scope.where(state: :expired) }
  scope("Deleted") { |scope| scope.where(state: :deleted) }
  scope("Not converted") { |scope| scope.where(state: [:active, :pending]).where(is_converted: false) }

  index do
    column :id
    column :track do |track|
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
    column :tags do |track|
      span status_tag track.state
      span status_tag track.type_of
      span status_tag "Raw" if track.is_converted == false
    end
    column :created do |track|
      time_ago(track.created_at)
    end
    column :updated do |track|
      time_ago(track.updated_at)
    end
    actions
  end

  show title: proc{|track| "#{track.title}" } do
    attributes_table do
      row :artist
      row :title
      row :duration do |track|
        track.duration
      end
      row :listen do |track|
        div audio_tag(track.track.url, controls: true)
      end
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
      end
      row :ref
    end
    active_admin_comments
  end

  form do |f|
    inputs 'Details' do
      input :artist
      input :title
      input :external_source
      input :state, as: :select, collection: Track.get_states.map { |value| value }, include_blank: false
      input :type_of, as: :select, collection: Track.get_types.map { |value| value }, include_blank: false
      input :is_converted
    end
    inputs 'Cover' do
      input :cover, as: :file, input_html: { accept:".jpeg,.jpg,.png,.gif" }
      li style: "background-image: url(#{resource.cover.url(:large)}); width: 150px; height: 150px; background-size: cover; margin-left: 20%; margin-top: -170px;"
    end
    inputs 'File' do
      input :track, as: :file, input_html: { accept:".mp3,.ogg" }
      track_image = resource.track_file_name ? "/missing/track_on.svg" : "/missing/track_off.svg"
      li style: "background-image: url(#{track_image}); width: 150px; height: 150px; background-size: cover; margin-left: 20%; margin-top: -170px;"
      li class: "form_content_margin" do
        "#{resource.track_file_name}"
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
