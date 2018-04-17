require "rails_helper"

describe "Playlist#get_non_jingle_track" do
  it "returns all tracks that are not jingles" do
    Playlist.get_non_jingle_tracks.where(:type_of => :jingle).should be_empty
  end
end

describe "Playlist#get_non_jingle_track_since" do
  it "returns all tracks that are not jingles since playlist" do
    playlist = Playlist.get_non_jingle_tracks.first
    Playlist.get_non_jingle_tracks_since(playlist).count.should eq Playlist.get_non_jingle_tracks.count - 1
  end
end

describe "Playlist#get_first_unaired" do
  it "returns the first unaired playlist" do
    Playlist.last.update! :is_aired => false
    Playlist.first.update! :is_aired => false

    Playlist.get_first_unaired.id.should eq Playlist.first.id
  end
end

describe "Playlist#get_last_aired" do
  it "returns the last aired playlist" do
    Playlist.last.update! :is_aired => true
    Playlist.get_last_aired.id.should eq Playlist.last.id
  end
end

describe "Playlist#should_play_jingle" do
  let (:last_track) { Track.create }

  it "returns true if it should" do
    Playlist.stub(:get_last_aired) { last_track }
    Rails.application.secrets.jingle_modulo = last_track.id

    Playlist.should_play_jingle.should be true
  end
  it "returns false if it should not" do
    Playlist.stub(:get_last_aired) { last_track }
    Rails.application.secrets.jingle_modulo = last_track.id + 1

    Playlist.should_play_jingle.should be false
  end
end

describe "Playlist#get_next_jingle" do
  before do
    Track.create :type_of => :jingle, :artist => "Jingle officiel"
  end

  it "returns Jingle Officiel when last_track.id % 2" do
    last_track = Track.find(2)
    Playlist.stub(:get_last_aired) { last_track }

    Playlist.get_next_jingle.type_of.should eq "jingle"
    Playlist.get_next_jingle.artist.should eq "Jingle officiel"
  end

  it "returns another Jingle if not" do
    last_track = Track.find(3)
    Playlist.stub(:get_last_aired) { last_track }

    Playlist.get_next_jingle.type_of.should eq "jingle"
    Playlist.get_next_jingle.artist.should eq "Jingle"
  end
end

describe "Playlist#get_last_auto_feat" do
  it "return the last auto feat played" do
    Playlist.first.update! :type_of => :auto_feat
    Playlist.last.update! :type_of => :auto_feat

    Playlist.get_last_auto_feat.id.should eq Playlist.last.id
  end
end

describe "Playlist#count_since_last_auto_feat" do
  it "returns how many non-jingle plays have happened since last auto feat" do
    Playlist.first.update! :type_of => :auto_feat
    Playlist.count_since_last_auto_feat.should eq Playlist.get_non_jingle_tracks.count - 1

    Playlist.last.update! :type_of => :auto_feat
    Playlist.count_since_last_auto_feat.should eq 0
  end

  it "return 0 when no auto feat was played" do
    Playlist.count_since_last_auto_feat.should eq 0
  end
end

describe "Playlist#get_artists_from_ids" do
  let (:playlist1) { Playlist.new :track_id => 2 }
  let (:playlist2) { Playlist.new :track_id => 3 }
  it "returns recently played artists" do
    Playlist.stub(:get_recently_played_tracks) { [playlist1, playlist2] }    
    artist1 = playlist1.track.artist
    artist2 = playlist2.track.artist

    artists = Playlist.get_artists_to_avoid
    artists.count.should eq 2
    artists.first.should eq artist1
    artists.last.should eq artist2
  end
end

describe "Playlist#get_tracks_to_avoid" do
  it "returns rencently played tracks" do
    Track.stub(:get_buffer_count) { 1 }
    tracks = Playlist.get_tracks_to_avoid
    tracks.count.should eq 1
    tracks.first.should be Playlist.last.track_id
  end
end

describe "Playlist#get_next_auto_feat_for_tag" do
  context "when it is time for an auto feat" do
    let (:track) { Track.new }

    it "returns the last aired track" do
      Rails.application.secrets.track_auto_featured_modulo = 2
      Playlist.stub(:count_since_last_auto_feat) { 3 }
      Track.stub(:get_next_auto_feat_for_tag) { track }

      Playlist.get_next_valid_auto_feat_for_tag(:default).should eq track
    end

    it "returns nil when no track is valid" do
      Rails.application.secrets.track_auto_featured_modulo = 2
      Playlist.stub(:count_since_last_auto_feat) { 3 }
      Track.stub(:get_next_auto_feat_for_tag) { nil }

      Playlist.get_next_valid_auto_feat_for_tag(:default).should be nil
    end
  end
  context "when it is not time for an auto feat" do
    it "returns nil" do
      Rails.application.secrets.track_auto_featured_modulo = 2
      Playlist.stub(:count_since_last_auto_feat) { 1 }

      expect(Track).not_to receive(:get_next_auto_feat_for_tag)
      Playlist.get_next_valid_auto_feat_for_tag(:default).should be nil
    end
  end
end
