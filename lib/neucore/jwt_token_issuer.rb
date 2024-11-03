# lib/neucore/jwt_token_issuer.rb
require 'jwt'

module Neucore
  module JwtTokenIssuer
    extend ActiveSupport::Concern

    included do
      attr_accessor :access_token
    end

    def generate_and_set_jwt_token
      payload = {
        sub: self.id,
        scp: self.class.to_s.underscore,
        iat: Time.current.to_i,
        iss: Neucore.configuration.jwt_issuer,  # Replace with an actual app identifier if needed
        exp: Time.current.to_i + Neucore.configuration.jwt_expiry_time
      }
      self.access_token = JWT.encode(payload, Neucore.configuration.jwt_secret_key)
    end
  end
end