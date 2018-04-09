require 'test_helper'

class AbilityTest < ActiveSupport::TestCase
  test "admin can manage all" do
    admin = admin_user :admin
    assert admin.admin?
    ability = Ability.new admin
    assert ability.can? :manage, :all
  end

  test "mcs have limited access to all" do
    mc = admin_user :mc
    assert mc.mc?
    refute mc.admin?

    ability = Ability.new mc
    refute ability.can? :manage, :all
    assert ability.can? :read, :all
  end

  test "mcs can manage artists" do
    mc = admin_user :mc
    ability = Ability.new mc
    assert ability.can? :manage, Artist
  end

  test "mcs can create tracks and update non-active ones" do
    mc = admin_user :mc
    ability = Ability.new mc
    assert ability.can? :create, Track
    pending_track = Track.new :state => 'pending'
    assert ability.can? :update, pending_track
    assert ability.can? :destroy, pending_track

    wip_track = Track.new :state => 'wip'
    assert ability.can? :update, wip_track
    assert ability.can? :destroy, wip_track

    rejected_track = Track.new :state => 'rejected'
    assert ability.can? :update, rejected_track
    assert ability.can? :destroy, rejected_track
  end
end
