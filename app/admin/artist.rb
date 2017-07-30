ActiveAdmin.register Artist do
  config.batch_actions = false

  actions :index, :destroy, :show

  collection_action :autocomplete_artist_name, method: :get

  controller do
    autocomplete :artist, :name, full: true, limit: 20
  end

  index do
    column :id
    column :name do |item|
      # link_to item.name, tracks_path(q: { artist_eq: item.name})
      auto_link item, item.name
    end
    column :tracks do |item|
      Track.where(artist: item.name).count
    end

    actions
  end

end
