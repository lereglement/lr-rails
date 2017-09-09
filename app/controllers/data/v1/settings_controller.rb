class Data::V1::SettingsController < Data::V1::BaseController

  def index
    render json: Setting.all,
      root: 'data',
      each_serializer: Data::V1::Settings::SettingSerializer
  end

end
