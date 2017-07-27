ActiveAdmin.register Track do

  permit_params :artist,
    :title,
    :length,
    :year,
    :bitrate,
    :bitrate_type_of,
    :is_converted,
    :track

  index do
    column :id
    column :artist
    column :title
    column :year
    column :created do |user|
      time_ago(user.created_at)
    end
    column :updated do |user|
      time_ago(user.updated_at)
    end
    actions
  end

  form do |f|
    inputs 'Details' do
      input :artist
      input :title
      input :length
      input :year
      input :bitrate, as: :select, collection: Track.get_bitrates
      input :bitrate_type_of, as: :select, collection: Track.get_bitrate_types
      input :is_converted, as: :check_boxes
      input :track, as: :file
    end
    actions
  end

end
