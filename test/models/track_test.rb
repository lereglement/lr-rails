require 'test_helper'

class TrackTest < ActiveSupport::TestCase
  test "roles can edit different states" do 
    mc_roles = ['mc']
    states_for_mc = Track.get_states_for_roles(mc_roles)
    refute states_for_mc.include?(:active)

    admin_roles = ['mc', 'admin']
    states_for_admin = Track.get_states_for_roles(admin_roles)
    assert states_for_admin.include?(:active)
  end
end
