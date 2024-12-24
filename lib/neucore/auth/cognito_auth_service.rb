# https://docs.aws.amazon.com/cognito-user-identity-pools/latest/APIReference/API_Operations.html
module Neucore
  class CognitoAuthService
    require 'aws-sdk-cognitoidentityprovider'

    attr_reader :model, :client, :user_pool_id, :client_id, :id_field

    def initialize model = nil
      @model ||= 'user'
      @client = Aws::CognitoIdentityProvider::Client.new(
        region: Rails.application.credentials.aws.region,
        access_key_id: Rails.application.credentials.aws.access_key_id,
        secret_access_key: Rails.application.credentials.aws.secret_access_key
      )
      @user_pool_id = Rails.application.credentials.aws.cognito[@model]['user_pool_id']
      @client_id = Rails.application.credentials.aws.cognito[@model]['client_id']
      @id_field = Rails.application.credentials.aws.cognito[@model]['id_field']
    end

    def list_users
      resp = client.list_users(user_pool_id: user_pool_id)
      resp
    end

    def admin_get_user username
      resp = client.admin_get_user(user_pool_id: user_pool_id, username: username)
    end

    def revoke_token token
      resp = client.revoke_token(client_id: client_id, token: token)
    end

    def sign_up!(opts = {})
      begin
        sign_up_params = {
          client_id: client_id,
          username: opts[:username],
          password: opts[:password]
        }
        user_attributes = []
        user_attributes << { name: "email", value: email } if email.present?
        user_attributes << { name: "phone_number", value: phone_number } if phone_number.present?
        sign_up_params[:user_attributes] = user_attributes if user_attributes.present?

        resp = client.sign_up(sign_up_params)
        token = confirm_sign_up!(opts[:username])
        resp[:user_sub]
      rescue Aws::CognitoIdentityProvider::Errors::ServiceError => e
        raise e
      end
    end

    def confirm_sign_up!(username)
      client.admin_confirm_sign_up(
        {
          user_pool_id: user_pool_id,
          username: username
        }
      )
    end

    def admin_initiate_auth! auth_flow = nil, auth_parameters = {}
      begin
        resp = client.admin_initiate_auth(
          {
            user_pool_id: user_pool_id,
            auth_flow: auth_flow,
            client_id: client_id,
            auth_parameters: auth_parameters
          }
        )
        resp.authentication_result
      rescue Aws::CognitoIdentityProvider::Errors::ServiceError => e
        if e.message == 'Password attempts exceeded'
          raise I18n.t('Password attempts exceeded')
        else
          raise e
        end
      end
    end

    def update_attributes!(opts = {})
      new_password = opts[:password]
      username = opts[:username]
      email = opts[:email]
      email_verified = opts[:email_verified]
      phone_number = opts[:phone_number]
      phone_number_verified = opts[:phone_number_verified]
      user_attributes = []
      user_attributes << { name: "email", value: email } if email.present?
      user_attributes << { name: "email_verified", value: 'true' } if email_verified.present?
      user_attributes << { name: "phone_number", value: phone_number } if phone_number.present?
      user_attributes << { name: "phone_number_verified", value: 'true' } if phone_number_verified.present?
      if user_attributes.present?
        client.admin_update_user_attributes(
          {
            user_pool_id: user_pool_id, # required
            username: username, # required
            user_attributes: user_attributes
          }
        )
      end

      if new_password.present?
        client.admin_set_user_password(
          {
            user_pool_id: user_pool_id,
            username: username,
            password: new_password,
            permanent: true
          }
        )
      end
    end

    def self.verify_token(token)
      payload = JWT.decode(token, nil, false).first rescue nil
      return false unless payload.present?

      iss = payload['iss']
      match = iss.match(/https:\/\/cognito-idp\.(.*?)\.amazonaws\.com\/(.*)/)
      return false unless match.present?

      cognito_config = Rails.application.credentials.aws.cognito.select{|_, v| v[:user_pool_id] == match[2]}
      return false unless cognito_config.present?
      cognito_config = cognito_config.first

      model = cognito_config[0].to_s
      id_field = cognito_config[1][:id_field]
      resource = model.classify.constantize.find_by(id_field => payload['sub'])
      return false unless resource

      begin
        jwks_url = "https://cognito-idp.#{Rails.application.credentials.aws.region}.amazonaws.com/#{match[2]}/.well-known/jwks.json"
        jwks_keys = fetch_jwks(jwks_url)
        JWT.decode(token, nil, true, { algorithms: ['RS256'], jwks: jwks_keys })
        [resource, model.underscore]
      rescue
        false
      end
    end

    private
    def self.fetch_jwks(url)
      response = Net::HTTP.get(URI(url))
      JSON.parse(response, symbolize_names: true)[:keys]
    end
  end
end