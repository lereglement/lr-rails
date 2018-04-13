require 'rails_helper'
require 'json'
require 'byebug'

describe Api::V1::PlaylistsController, :type => :controller do
  context "during regular hours" do
    before do
      time = Time.zone.local(2018, 1, 1, 15)
      Time.zone.stub(:now).and_return(time)
    end

    context "when there is a Playlist that is not played yet" do
      let(:track) { Track.last }
      let(:playlist) { Playlist.last }

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
    context "when all Playlists have been played"
  end
  context "during rap us hours"
end
