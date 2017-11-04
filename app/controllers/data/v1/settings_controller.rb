class Data::V1::SettingsController < Data::V1::BaseController
  
  skip_before_action :authenticate_request!, only: [:index]

  def index
    render json: Setting.all,
      root: 'data',
      each_serializer: Data::V1::Settings::SettingSerializer
  end

end
