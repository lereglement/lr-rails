Paperclip::Attachment.default_options.update({
  url: "/system/:class/:attachment/:id_partition/:style/:hash.:extension",
  hash_secret: Rails.application.secrets.media_hash
})
