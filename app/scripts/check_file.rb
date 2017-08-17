require 'net/http'

tracks = Track.where(state: Track.get_state_to_check, is_converted: true)

tracks.each do |track|
  errors = []

  # Check source
  errors.push("Filename missing in db") unless track.track.path
  if track.track.path
    uri = URI(track.track.url)
    request = Net::HTTP.new uri.host
    response = request.request_head uri.path
    errors.push("Header for file #{response.code}") if response.code.to_i != 200
  end

  errors.push("Duration missing") unless track.duration
  errors.push("Duration converted missing") unless track.duration_converted

  track.update(error_logs: errors.join(','), state: :to_review)

  if errors
    Bucket.where(track_id: track.id).delete_all
  end

end
