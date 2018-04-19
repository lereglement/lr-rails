require "rails_helper"
require "byebug"

describe "Track" do
  describe "get_artists_from_ids" do
    it "returns an array of artist names" do
      artist1 = Track.first.artist
      artist2 = Track.last.artist
      artists = Track.get_artists_from_ids([Track.first.id, Track.last.id])
      artists.count.should == 2
      artists.first.should eq artist1
      artists.last.should eq artist2
    end

    it "returns empty array if no id is passed" do
      Track.get_artists_from_ids([]).should be_empty
    end
  end

  describe "get_playable_tracks_for_tag" do
    it "returns list of active, converted tracks with tag" do
      Track.get_playable_tracks_for_tag(:default).each do |track|
        track.state.should eq "active"
        track.is_converted.should be true
        track.type_of.should eq "track"
      end
    end
  end

  describe "filter_artists_for_tag" do
    it "returns tracks for tag without artists" do
      artist = Track.filter_tag(:default).last.artist
      artists = Track.filter_artists_for_tag(:default, [artist]).map(&:artist)
      artists.include?(artist).should be false
    end
  end

  describe "get_random_track_for_tag_filtered_for_artists" do
    it "returns a random track" do
      Track.stub(:filter_artists_for_tag) { [Track.new, Track.new, Track.new] }
      Track.get_random_track_for_tag_filtered_for_artists(:default, [])
        .should be_kind_of Track
    end
  end
end

