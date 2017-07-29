ActiveAdmin.register Artist do
  config.batch_actions = false

  actions :index, :destroy, :show

  collection_action :autocomplete_artist_name, method: :get

  controller do
    autocomplete :artist, :name, full: true, limit: 20
  end

end
