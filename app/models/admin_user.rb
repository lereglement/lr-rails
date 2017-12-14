class AdminUser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  # This scope allows to query AdminUsers by role
  # ex: AdminUser.with_role("admin")
  scope :with_role, ->(role) {{:conditions => "roles_mask & #{2**ROLES.index(role.to_s)} > 0 "}}

  # AdminUser's roles are stored in a bitmask, only append new roles to end of list
  ROLES = %w[admin mc]

  def role_symbols
    roles.map(&:to_sym)
  end

  # Set the AdminUser's roles mask with a bitmask
  def roles=(roles)
    self.roles_mask = (roles & ROLES).map { |r| 2**ROLES.index(r) }.sum
  end

  # Return the AdminUser's roles
  def roles
    ROLES.reject { |r| ((roles_mask || 0) & 2**ROLES.index(r)).zero? }
  end
end
