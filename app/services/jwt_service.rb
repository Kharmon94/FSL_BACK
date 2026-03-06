# frozen_string_literal: true

class JwtService
  SECRET = Rails.application.secret_key_base
  ALGORITHM = "HS256"
  EXPIRY = 24.hours

  def self.encode(payload, exp: EXPIRY)
    payload[:exp] = exp.from_now.to_i
    JWT.encode(payload, SECRET, ALGORITHM)
  end

  def self.decode(token)
    body = JWT.decode(token, SECRET, true, { algorithm: ALGORITHM })[0]
    HashWithIndifferentAccess.new(body)
  rescue JWT::DecodeError
    nil
  end
end
