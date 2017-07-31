Paperclip::Attachment.default_options.update({
  url: "/system/:class/:attachment/:id_partition/:style/:hash.:extension",
  hash_secret: Rails.application.secrets.media_hash
})

Paperclip::Attachment.default_options[:s3_host_name] = Rails.application.secrets.s3_host_name

Paperclip.options[:content_type_mappings] = {
  :mp3 => "application/octet-stream"
}
