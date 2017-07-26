class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

    def extract_image_data(obj)
      if obj.content_type =~ %r{^(image|(x-)?application)/(bmp|gif|jpeg|jpg|pjpeg|png|x-png)$}
        tempfile = obj.queued_for_write[:original]
        unless tempfile.nil?
          geometry = Paperclip::Geometry.from_file(tempfile)
          image = MiniMagick::Image.open(tempfile.path)
          image.resize '1x1'
          pixels = image.get_pixels
          unless pixels == []
            pixels = pixels[0][0]
          end
          {
            color: ImageLib.rgb(pixels[0] ? pixels[0] : 255, pixels[1] ? pixels[1] : 255, pixels[2] ? pixels[2] : 255).downcase,
            width: geometry.width.to_i,
            height: geometry.height.to_i
          }
        end
      end
    end

end
