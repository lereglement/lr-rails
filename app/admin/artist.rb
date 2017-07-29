ActiveAdmin.register Artist do

  collection_action :autocomplete_artist_name, method: :get

  controller do
    autocomplete :artist, :name, full: true, limit: 20
  end

end
