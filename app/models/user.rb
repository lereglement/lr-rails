class User < ApplicationRecord

  belongs_to :facebook_user, optional: true

  after_create :add_ref

  STATES = [
    :active,
    :pending,
    :deleted
  ]

  def add_ref
    passphrase = "#{self.id}--#{Rails.application.secrets.secret_key_base}"
    self.update_columns(ref: CryptLib.sha1(passphrase))
  end

  def self.get_states
    STATES
  end

end
