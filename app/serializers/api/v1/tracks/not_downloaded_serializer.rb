class Api::V1::Tracks::NotDownloadedSerializer < ActiveModel::Serializer

  attributes :ref

  attribute :external do
    ExternalResourceLib.extract_from_url(object.external_source)
  end

end
