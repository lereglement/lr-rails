require "rails_helper"

describe "Bucket#get_random_track_for_tag" do
  let (:track) { Track.create :artist => "Valid artist" }

  before do
    Bucket.update_all :tag_id => Tag.get_id(:default)
  end

  context "when a bucket is available" do
    before do
      Bucket.create :track_id => track.id,
                    :artist => track.artist,
                    :tag_id => Tag.get_id(:us)
    end
    
    it "returns a track" do
      Bucket.get_random_track_for_tag(:us).track_id.should eq track.id
    end
  end

  context "when no bucket is available" do
    it "returns nil" do
      Bucket.get_random_track_for_tag(:us).should be_nil
    end
  end
end
