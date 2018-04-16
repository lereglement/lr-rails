require "rails_helper"

describe Tag do
  it "returns default tag during regular hours" do
    Tag.get_current_tag_name.should eq(:default)
  end

  it "returns us tag Monday night from 21h to 23:59h" do
    allow(Time).to receive(:now).and_return(Time.zone.local(2018, 1, 1, 22))

    Tag.get_current_tag_name.should eq(:us)
  end
end
