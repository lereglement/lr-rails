class TrackLib

  def self.transcoded_file(object)
    filename = object.track.path.scan(/original\/(\w+)/)[0][0]
    "/transcoded/#{filename.scan(/.{4}/).join("/")}/#{Rails.application.secrets.output_quality}.#{Rails.application.secrets.output_format}"
  end
  
end
