require "byebug"
require "rails_helper"
require "json"

describe Api::V1::PlaylistsController, :type => :controller do
  let(:track) { Track.last }
  let(:playlist) { Playlist.last }

  context "during regular hours" do
    before do
      time = Time.zone.local(2018, 1, 1, 15)
      Time.zone.stub(:now).and_return(time)
    end

    context "when there is a Playlist that is not played yet" do
      before(:each) do
        playlist.update!(:is_aired => false, :track_id => track.id)
        track.update!(:last_aired_at => nil, :aired_count => 0)
      end

      it "updates the playlist" do
        get :get_next
        playlist.reload
        playlist.aired_at.should > Time.zone.now - 1.seconds
        playlist.is_aired.should be true
      end

      it "finds the related track and updates it" do
        get :get_next
        track.reload
        track.last_aired_at.should > Time.zone.now - 1.seconds
        track.aired_count.should == 1
      end

      it "returns serialized json" do
        resp = get :get_next
        data = JSON.parse(resp.body).fetch("data")

        data.should_not be nil
        data.fetch("artist").should == track.artist
        data.fetch("title").should == track.title
      end
    end

    context "when all Playlists have been played" do
      let(:jingle) { Track.first }

      before do
        playlist.update!(:is_aired => true)
      end

      context "and it is jingle time" do
        context "and it fins a jingle" do
          before do
            jingle.update!(:artist => "Jingle officiel")
          end

          it "creates a jingle" do
            Rails.application.secrets.jingle_modulo = playlist.id
            resp = get :get_next
            data = JSON.parse(resp.body).fetch("data")

            data.should_not be nil
            data.fetch("artist").should == jingle.artist
            data.fetch("type_of").should == jingle.type_of
          end
        end

        context "but it does not find a jingle" do
          context "if its time for an auto feature" do
            context "and it finds an auto feature" do
              before do
                Playlist.first.update!(:type_of => :auto_feat)
              end

              it "creates a Playlist for this autofeature" do
                Rails.application.secrets.track_auto_featured_limit = 0
                Rails.application.secrets.track_auto_featured_limit = 999
                Track.first.update!(:type_of => :auto_feat)
                resp = get :get_next
                data = JSON.parse(resp.body).fetch("data")
                data.fetch("type_of").should == "auto_feat"
              end
            end
            context "but an auto feature is not found" do
              context "a bucket is picked" do
                it "creates a Playlist for the bucket" do
                  Bucket.stub(:pick_next) { Bucket.create :track_id => 5 }
                  get :get_next
                  Playlist.last.track_id.should eq 5
                end
              end
              context "a bucket is not picked" do
                before { Bucket.stub(:pick_next) { nil } }

                context "and it can find a track of a wanted artist" do
                  track = Track.last
                  it "creates a Playlist for it" do
                    Track.stub(:get_random_track_for_tag_filtered_for_artists) do
                      track
                    end
                    get :get_next
                    Playlist.last.track_id.should eq track.id
                  end
                end
              end
            end
          end
        end
      end
    end
  end

  context "during rap us hours" do
    before do
      time = Time.zone.local(2018, 4, 16, 22)
      Time.zone.stub(:now).and_return(time)
    end

    context "when there is a Playlist that is not played yet" do
      before(:each) do
        playlist.update!(:is_aired => false, :track_id => track.id)
        track.update!(:last_aired_at => nil, :aired_count => 0)
      end

      it "gets a us rap track" do
        resp = get :get_next
        data = JSON.parse(resp.body).fetch("data")

        data.fetch("artist").should == track.artist
      end
    end
  end
end
