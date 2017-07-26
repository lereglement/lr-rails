class ImageLib

  def self.rgb(r, g, b)
    "##{to_hex r}#{to_hex g}#{to_hex b}"
  end

  def self.to_hex(n)
    n.to_s(16).rjust(2, '0').upcase
  end

  def self.type_to_extension(type)
    type.split('/')[1] if type
  end

  def self.get_path(ref, content_type, size = nil, shape = nil)
    path = "#{Rails.application.secrets.domain_image_url}/{size}/{target}/#{ref}.#{ImageLib.type_to_extension(content_type)}"
    path.sub! "{size}", size.to_s unless size.nil?
    path.sub! "{target}", shape.to_s unless shape.nil?
    path
  end

  def self.get_source_path(url)
    if url[0..1] == "//"
        "https:#{url}"
    elsif url[0..6] == "http://" || url[0..7] == "https://"
        url
    else
      "#{Rails.root}/public#{url}"
    end
  end

end
