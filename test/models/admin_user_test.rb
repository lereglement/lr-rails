require 'test_helper'

class AdminUserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "admin users have roles" do
    admin = admin_user :admin
    assert admin.admin?
    refute admin.mc?
    assert admin.roles == ['admin']

    mc = admin_user :mc
    assert mc.mc?
    refute mc.admin?
    assert mc.roles == ['mc']

    admin_mc = admin_user :admin_mc
    assert admin_mc.admin?
    assert admin_mc.mc?
    assert admin_mc.roles == ['admin', 'mc']
  end

  test "update admin user roles" do
    mc = admin_user :mc
    refute mc.admin?
    mc.roles = ['mc', 'admin']
    assert mc.admin?
  end

  test "get roles symbols" do
    admin_mc = admin_user :admin_mc
    assert admin_mc.role_symbols == [:admin, :mc]
  end
end
