# lib/neucore/jwt_token_issuer.rb
require 'jwt'

module Neucore
  class InHouseAuthService
    class << self
      def issue_token(resource)
        payload = {
          sub: resource.id,
          scp: resource.class.to_s.underscore,
          iat: Time.current.to_i,
          iss: Neucore.configuration.jwt_issuer, # Replace with an actual app identifier if needed
          exp: Time.current.to_i + Neucore.configuration.jwt_expiry_time
        }
        access_token = JWT.encode(payload, Neucore.configuration.jwt_secret_key)
        refresh_token = "placeholder"
        {
          access_token: access_token,
          refresh_token: refresh_token
        }
      end
    end

    def sign_in!(opts = {})
      field = opts[:login]
      model = opts[:model]
      raise Neucore::Unauthorized, "Invalid credentials" unless field

      username = opts[:username]
      password = opts[:password]

      klass = model.to_s.classify.constantize # Dynamically determine the model class
      resource = klass.find_by(field => username)

      if resource && resource.valid_password?(password) # Assuming `has_secure_password`
        issue_token(resource)
      else
        raise Neucore::Unauthorized, "Invalid credentials"
      end
    end

    def verify_token(token)
      jwt_payload = JWT.decode(token, Neucore.configuration.jwt_secret_key).first rescue nil
      return false if jwt_payload.nil?

      id = jwt_payload['sub']
      scp = jwt_payload['scp']
      exp = jwt_payload['exp']
      exp = Time.at(exp) || Time.yesterday
      return false if exp < Time.now

      cont = scp.to_s.classify.constantize rescue nil
      return false unless cont

      resource = cont.find_by(id: id)
      return false unless resource
      [resource, scp]
    end

    def sign_up!(opts = {})
      field = opts[:login]
      model = opts[:model]
      auto_sign_in = !!opts[:auto_sign_in]
      raise Neucore::Unauthorized, "Invalid credentials" unless field

      username = opts[:username]
      password = opts[:password]

      klass = model.to_s.classify.constantize # Dynamically determine the model class
      resource = klass.find_or_initialize_by(field => username)
      resource.password = password if password
      token = resource.save!
      token = issue_in_house_token(resource) if auto_sign_in
      token
    end
  end
end