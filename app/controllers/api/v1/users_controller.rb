class Api::V3::UsersController < Api::V3::BaseController

  def me
    me = User.find(current_user.id)

    render json: me,
      root: 'data',
      serializer: Api::V3::Users::MeSerializer,
      scope: pass_scope
  end

  def show
    user = User.find_by(ref: params[:id])
    api_error(status: 404, errors: "User missing") and return false unless user

    if params[:from_connection]
      Connection
        .where(user_id: current_user[:id], user_id_target: user[:id])
        .first
        .update(is_visited: true)
    end

    render json: user,
      root: 'data',
      serializer: Api::V3::Users::ProfileSerializer,
      scope: pass_scope
  end

  def update_me
    me = User.find(current_user.id)
    if !params[:user].nil?
      user_params = params[:user].permit(
        :first_name,
        :age,
        :description,
        :gender,
        :gender_target,
        :theme,
        :range,
        :age_min,
        :age_max,
        :latitude,
        :longitude,
        :is_email_match,
        :is_email_message,
        :is_email_selection,
        :is_notification_match,
        :is_notification_message,
        :is_notification_selection
      )
      me.update(user_params)
      api_error(status: 500, errors: me.errors) and return false unless me.valid?
    end

    render json: me,
      root: 'data',
      serializer: Api::V3::Users::MeSerializer,
      scope: pass_scope
  end

  def activate
    errors = User.completion_error(current_user)
    api_error(status: 401, errors: errors) and return false if errors.count > 0

    current_user.update(is_onboarded: true)

    # Creating discussion with admin
    discussion_user_ids = DbLib.get_user_ids(User.get_user_id_admin, current_user[:id])
    discussion = Discussion.where(user_ids: discussion_user_ids).first_or_create

    if discussion.message_count == 0
      discussion.discussion_messages.create(
        message: Copywriting.get_content(:WELCOME),
        user_id: User.get_user_id_admin,
        user_id_target: current_user[:id]
      )
    end

    render json: current_user,
      root: 'data',
      serializer: Api::V3::Users::MeSerializer,
      scope: pass_scope
  end

  def themes
    themes = []
    User.get_themes.each do |key,value|
      themes.push({ ref: key }.merge(value))
    end
    render json: themes,
      root: 'data'
  end

end
