ActiveAdmin.register Tag do
  config.batch_actions = false

  actions :all

  permit_params :name

  filter :name_contains

end
