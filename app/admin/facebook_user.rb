# encoding: UTF-8
ActiveAdmin.register FacebookUser do

  menu parent: "Admin", label: "Facebook"

  config.sort_order = 'updated_at_desc'

  actions :all, :except => [:new, :destroy]

  filter :facebook_ref_equals
  filter :first_name_contains
  filter :last_name_contains

  index do
    column :id
    column :name do |facebook_user|
      auto_link(facebook_user, "#{facebook_user.first_name} #{facebook_user.last_name}")
    end
    column :user do |facebook_user|
      user = facebook_user.user
      auto_link(user, "##{user.id} #{user.first_name}") if user
    end
    column :gender
    column :email
    column :created do |discussion|
      time_ago(discussion.created_at)
    end
    column :updated do |discussion|
      time_ago(discussion.updated_at)
    end
    actions
  end


end
