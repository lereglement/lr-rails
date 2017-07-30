ActiveAdmin.register Artist do
  config.batch_actions = false

  actions :all

  permit_params :twitter

  collection_action :autocomplete_artist_name, method: :get

  controller do
    autocomplete :artist, :name, full: true, limit: 20
  end

  index do
    column :id
    column :artist do |artist|
      div style: "display:flex; align-items: center;" do
        div auto_link(artist, image_tag(artist.picture.url(:xsmall), size: 50, style: "margin-right: 10px;"))
        div auto_link(artist, artist.name)
      end
    end
    column :twitter do |artist|
      div do
        artist.twitter.split.each do |account|
          span link_to "#{account}", "https://twitter.com/#{account}", target: "_blank"
        end
      end if artist.twitter
    end
    column :tracks do |artist|
      Track.where(artist: artist.name).count
    end

    actions
  end

  show do
    attributes_table do
      row :name
      row :twitter do |artist|
        div do
          artist.twitter.split.each do |account|
            span link_to "#{account}", "https://twitter.com/#{account}", target: "_blank"
          end
        end
      end if artist.twitter
    end

    tracks = Track.where(artist: resource.name).order(:id)
    if tracks.count > 0
      panel "Tracks" do
        table_for tracks do
          column :id
          column :title do |track|
            div style: "display:flex; align-items: center;" do
              div auto_link(track, image_tag(track.cover.url(:xsmall), size: 50, style: "margin-right: 10px;"))
              div auto_link(track, track.title.length > 0 ? track.title : track.track_file_name)
            end
          end
          column :aired_count
          column :last_aired_at
        end
      end
    end

    active_admin_comments

  end

  form do |f|
    inputs 'Details' do
      input :name, input_html: { disabled:"disabled" }
      input :twitter
    end
    inputs 'Picture' do
      input :picture, as: :file, input_html: { accept:".jpeg,.jpg,.png,.gif" }
      li style: "background-image: url(#{resource.picture.url(:large)}); width: 150px; height: 150px; background-size: cover; margin-left: 20%; margin-top: -170px;"
    end
    actions
  end

  sidebar "Details", only: :show do
    div do
      div image_tag(resource.picture.url(:large), size: 250)
      div b "Created: #{time_ago(resource.created_at)}"
      div b "Updated: #{time_ago(resource.updated_at)}"

    end
  end

end
