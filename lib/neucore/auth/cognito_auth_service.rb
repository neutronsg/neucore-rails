module Neucore
  class CognitoAuthService
    require 'aws-sdk-cognitoidentityprovider'

    class << self
      def set_cognito(opts = {})
        model = opts[:model]
        mappings = Neucore.configuration.cognito_fields_mapping
        mapping = mappings.select { |m| m[:model] == model }.first
        @client = Aws::CognitoIdentityProvider::Client.new(region: mapping[:region])
        @user_pool_id = mapping[:user_pool_id]
        @client_id = mapping[:client_id]
      end

      def refresh_token!(refresh_token)
        begin
          resp = @client.initiate_auth(
            {
              auth_flow: 'REFRESH_TOKEN',
              client_id: @client_id,
              auth_parameters: {
                'REFRESH_TOKEN' => refresh_token
              }
            }
          )
          # Extract the JWT tokens from the response
          {
            access_token: resp.authentication_result.id_token,
            # access_token: resp.authentication_result.access_token,
            refresh_token: resp.authentication_result.refresh_token
          }
        rescue Aws::CognitoIdentityProvider::Errors::ServiceError => e
          raise "Cognito authentication failed: #{e.message}"
        end
      end

      # Sign up user (create new user in Cognito)
      def sign_up!(opts = {})
        set_cognito(opts)
        username = opts[:username]
        phone_number = opts[:phone_number]
        password = opts[:password]
        email = opts[:email]
        auto_sign_in = !!opts[:auto_sign_in]
        begin
          sign_up_params = {
            client_id: @client_id,
            username: username,
            password: password
          }
          user_attributes = []
          user_attributes << { name: "email", value: email } if email.present?
          user_attributes << { name: "phone_number", value: phone_number } if phone_number.present?
          sign_up_params[:user_attributes] = user_attributes if user_attributes.present?
          @client.sign_up(sign_up_params)
          token = confirm_sign_up!(username)
          if auto_sign_in
            {
              access_token: token.authentication_result.id_token,
              refresh_token: token.authentication_result.refresh_token
            }
          else
            true
          end
        rescue Aws::CognitoIdentityProvider::Errors::ServiceError => e
          raise e
        end
      end

      def confirm_sign_up!(username)
        @client.admin_confirm_sign_up(
          {
            user_pool_id: @user_pool_id, # required
            username: username # required
          }
        )
      end

      def sign_in!(opts = {})
        set_cognito(opts)
        Rails.logger.debug "FFFFFFFFFFFFFF #{opts}"
        username = opts[:username]
        password = opts[:password]
        begin
          resp = @client.initiate_auth(
            {
              auth_flow: 'USER_PASSWORD_AUTH',
              client_id: @client_id,
              auth_parameters: {
                'USERNAME' => username,
                'PASSWORD' => password
              }
            }
          )
          # Extract the JWT tokens from the response
          {
            access_token: resp.authentication_result.id_token,
            # access_token: resp.authentication_result.access_token,
            refresh_token: resp.authentication_result.refresh_token
          }
        rescue Aws::CognitoIdentityProvider::Errors::ServiceError => e
          raise e
        end
      end

      def verify_token(token)
        payload = JWT.decode(token, nil, false).first rescue nil
        return false unless payload.present?

        iss = payload['iss']
        match = iss.match(/https:\/\/cognito-idp\.(.*?)\.amazonaws\.com\/(.*)/)
        sub = payload['sub']

        return false unless match.present?

        pool_id = match[2]

        mappings = Neucore.configuration.cognito_fields_mapping
        mapping = mappings.select { |m| m[:user_pool_id] == pool_id }.first
        region = mapping[:region]
        model = mapping[:model]
        id_field = mapping[:id_field]
        cont = model.to_s.classify.constantize rescue nil
        return false unless cont

        resource = cont.find_by(id_field => sub)
        return false unless resource

        begin
          jwks_url = "https://cognito-idp.#{region}.amazonaws.com/#{pool_id}/.well-known/jwks.json"
          jwks_keys = fetch_jwks(jwks_url)
          JWT.decode(token, nil, true,
                     {
                       algorithms: ['RS256'],
                       jwks: jwks_keys
                     }
          )
          [resource, model.underscore]
        rescue
          false
        end
      end

      def fetch_jwks(url)
        response = Net::HTTP.get(URI(url))
        JSON.parse(response, symbolize_names: true)[:keys]
      end

    end
  end
end