ActiveAdmin.register Track do

  permit_params :artist,
    :title,
    :length,
    :year,
    :bitrate,
    :bitrate_type_of,
    :is_converted,
    :track

  form do |f|
    inputs 'Details' do
      input :artist
      input :title
      input :length
      input :year
      input :bitrate
      input :bitrate_type_of
      input :is_converted, as: :check_boxes
      input :track, as: :file
    end
    actions
  end

end
