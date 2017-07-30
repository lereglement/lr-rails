class Artist < ApplicationRecord

  has_attached_file :picture, styles: {
    xsmall: '100x100#',
    small: '200x200#',
    medium: '400x400#',
    large: '600x600#',
    xlarge: '800x800#',
  }, :default_url => "/missing/artist.svg",
  use_timestamp: false
  validates_attachment_content_type :picture, :content_type => /\Aimage\/.*\Z/

end
