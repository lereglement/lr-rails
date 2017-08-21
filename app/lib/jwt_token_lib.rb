class JwtTokenLib

  # Encodes and signs JWT Payload with expiration
  def self.encode(payload)
    payload.reverse_merge!(meta)
    JWT.encode payload, Rails.application.secrets.secret_key_base, 'HS256'
  end

  # Decodes the JWT with the signed secret
  def self.decode(token)
    JWT.decode token, Rails.application.secrets.secret_key_base, true, { :algorithm => 'HS256' }
  end

  # Validates the payload hash for expiration and meta claims
  def self.valid_payload(payload)
    if expired(payload) || payload['iss'] != meta[:iss] || payload['aud'] != meta[:aud]
      return false
    else
      return true
    end
  end

  # Default options to be encoded in the token
  def self.meta
    {
      exp: Rails.application.secrets.jwt_delay.hours.from_now.to_i,
      iss: Rails.application.secrets.jwt_issuer,
      aud: Rails.application.secrets.jwt_audience,
      iat: Time.now
    }
  end

  # Validates if the token is expired by exp parameter
  def self.expired(payload)
    Time.at(payload['exp']) < Time.now
  end
end
