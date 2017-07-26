Paperclip::Attachment.default_options.update({
  s3_host_name: Rails.application.secrets.aws_host,
  url: "/system/:class/:attachment/:id_partition/:style/:hash.:extension",
  hash_secret: Rails.application.secrets.media_hash
})
