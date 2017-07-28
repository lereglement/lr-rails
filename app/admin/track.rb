ActiveAdmin.register Track do

  actions :all, :except => [:destroy]

  permit_params :artist,
    :title,
    :duration,
    :year,
    :bitrate,
    :is_converted,
    :track,
    :state,
    :type_of

  index do
    column :id
    column :track do |track|
      div b track.artist
      div do
        span track.title
        span " (#{track.year})" if track.year
      end
    end
    column :tags do |track|
      span status_tag track.state
      span status_tag track.type_of
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
      row :year
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
      input :year
      input :state, as: :select, collection: Track.get_states.map { |value| value }, include_blank: false
      input :type_of, as: :select, collection: Track.get_types.map { |value| value }, include_blank: false
      input :is_converted
      input :track, as: :file
    end
    actions
  end

  sidebar "Details", only: :show do
    div do
      div b "Created: #{time_ago(resource.created_at)}"
      div b "Updated: #{time_ago(resource.updated_at)}"
      div b "Uploaded: #{time_ago(resource.track_updated_at)}" if resource.track_updated_at
      div "Bitrate: #{resource.bitrate}" if resource.bitrate
      div "Type: #{resource.track_content_type}" if resource.track_content_type

    end
  end

end
