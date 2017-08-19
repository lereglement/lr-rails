ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }


  content title: "Welcome" do
    columns do

      column do
        most_played = Track.where(state: :active, type_of: :track).order(aired_count: :desc).limit(50)

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
        pending = Track.where(state: :pending, type_of: :track).order(id: :desc).limit(30)

        panel "Pending" do
          table do
            pending.map do |track|
              tr do
                td do
                  div b link_to(track.title, track_path(track))
                end
              end
            end
          end unless pending.blank?
        end

        to_review = Track.where(state: :to_review, type_of: :track).order(id: :desc).limit(50)

        panel "To Review" do
          table do
            to_review.map do |track|
              tr do
                td do
                  div b link_to(track.title, track_path(track))
                end
              end
            end
          end unless to_review.blank?
        end

      end

      column do
        playlist = Playlist.where(is_aired: true, type_of: :track).order(id: :desc).limit(50)

        panel "Recently played" do
          table do
            playlist.map do |item|
              track = item.track
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
        end unless playlist.blank?

      end



    end
  end

end
