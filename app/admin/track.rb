ActiveAdmin.register Track do

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
    column :artist
    column :title
    column :year
    column :type do |track|
      status_tag track.type_of
    end
    column :created do |track|
      time_ago(track.created_at)
    end
    column :updated do |track|
      time_ago(track.updated_at)
    end
    actions
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

end
