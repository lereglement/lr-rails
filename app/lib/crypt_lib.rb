class CryptLib

  def self.md5(val)
    require 'digest/md5'
    Digest::MD5.hexdigest(val)
  end

  def self.sha1(val)
    require 'digest/sha1'
    Digest::SHA1.hexdigest(val)
  end

end
