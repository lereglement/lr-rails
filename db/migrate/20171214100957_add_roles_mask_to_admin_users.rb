class AddRolesMaskToAdminUsers < ActiveRecord::Migration[5.1]
  def up
    add_column :admin_users, :roles_mask, :integer

    AdminUser.update_all roles_mask: 3
  end

  def down
    remove_column :admin_users, :roles_mask
  end
end
