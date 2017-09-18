ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }


  content title: "Welcome" do

    columns do

      column do
        most_played = Track.filter_tag(:default).where(state: :active, type_of: :track).order(aired_count: :desc).limit(50)

        panel "Most played" do
          table do
            most_played.map do |track|
              tr do
                td do
                  div b link_to(track.title, track_path(track))
                end
                td style: "width: 40px" do
                  div track.aired_count
                end
              end
            end
          end
        end unless most_played.blank?

      end

      column do

        new_tracks = Track
          .filter_tag(:default)
          .where(state: :active, type_of: :track)
          .where("aired_count <= ?", Rails.application.secrets.track_new_limit)
          .order(id: :desc).limit(50)

        panel "New" do
          table do
            new_tracks.map do |track|
              tr do
                td do
                  div b link_to(track.title, track_path(track))
                end
              end
            end
          end unless new_tracks.blank?
        end

        auto_featured_tracks = Track
          .filter_tag(:default)
          .where(state: :active, type_of: :track)
          .where("aired_count <= ?", Rails.application.secrets.track_auto_featured_limit)
          .order(id: :desc).limit(50)

        panel "Auto-featured" do
          table do
            auto_featured_tracks.map do |track|
              tr do
                td do
                  div b link_to(track.title, track_path(track))
                end
                td style: "width: 40px" do
                  div track.aired_count
                end
              end
            end
          end unless auto_featured_tracks.blank?
        end

      end

      column do
        hours = Track.get_hours(10000000)
        hours_less_than_30 = Track.get_hours(30)
        hours_less_than_20 = Track.get_hours(20)

        panel "Stats" do
          table do
            tr do
              td do
                div b "Every active tracks"
              end
              td style: "width: 40px" do
                "#{hours} hours"
              end
            end
            tr do
              td do
                div b "Played less than 30 times"
              end
              td style: "width: 40px" do
                "#{hours_less_than_30} hours"
              end
            end
            tr do
              td do
                div b "Played less than 20 times"
              end
              td style: "width: 100px" do
                "#{hours_less_than_20} hours"
              end
            end
          end
        end

      end



    end
  end

end
