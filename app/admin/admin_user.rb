ActiveAdmin.register AdminUser do
  menu parent: "Admin", label: "Admin users"

  permit_params :email, :password, :password_confirmation, roles: []

  controller do
    def create
      @user = AdminUser.new(permitted_params[:admin_user])
      @user.roles = permitted_params[:admin_user][:roles]
      super
    end

    def update
      @user = AdminUser.find_by(email: permitted_params[:admin_user][:email])
      @user.roles = permitted_params[:admin_user][:roles]
      super
    end
  end

  index do
    selectable_column
    id_column
    column :email
    column :roles
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
  end

  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs "Admin Details" do
      f.input :email
      f.input :roles, as: :check_boxes, collection: AdminUser::ROLES
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

end
