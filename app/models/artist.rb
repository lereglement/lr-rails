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

  after_save :check_tracks

  def check_tracks

    if self.name != self.name_before_last_save
      id = self.id
      new_name = self.name
      name_before = self.name_before_last_save
      other = Artist.where.not(id: self.id).find_by(name: self.name)

      if other
        self.delete
        other.update_column(:name, new_name)
        other.update_column(:id, id)
      else
        self.update_column(:name, self.name)
      end

      Track.where(artist: name_before).update_all(artist: new_name)
    end

  end

end
