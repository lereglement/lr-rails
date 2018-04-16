require "rails_helper"
require "byebug"

describe "Track#get_artists_from_ids" do
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
