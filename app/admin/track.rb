ActiveAdmin.register Track do

  permit_params :artist,
    :title,
    :duration,
    :year,
    :bitrate,
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
      input :duration
      input :year
      input :bitrate
      input :is_converted, as: :check_boxes
      input :track, as: :file
    end
    actions
  end

end
