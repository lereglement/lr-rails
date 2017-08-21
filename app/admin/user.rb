# encoding: UTF-8
ActiveAdmin.register User do
  menu parent: "Admin", label: "Users"

  config.sort_order = 'updated_at_desc'


end
