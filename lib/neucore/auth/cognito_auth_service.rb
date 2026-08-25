module Neucore
  class CognitoAuthService
    require 'aws-sdk-cognitoidentityprovider'
    require 'base64'
    require 'openssl'

    class << self
      def set_cognito(opts = {})
        model = opts[:model] || "user"
        client_key = opts[:client_key] || :client_id
        client_key = client_key.to_sym
        mapping = Neucore.configuration.cognito_fields_mapping[model]
        @client = Aws::CognitoIdentityProvider::Client.new(
          region: mapping[:region],
          access_key_id: Neucore.configuration.aws_access_key_id,
          secret_access_key: Neucore.configuration.aws_secret_access_key
        )
        @user_pool_id = mapping[:user_pool_id]
        @client_id = mapping[client_key]
        @client_secret = mapping[:client_secret]
      end

      # @param opts [Hash] - options for authentication
      # opts[:model] - the model to authenticate (e.g., :user, :admin)
      # opts[:username] - unique identifier of user
      # opts[:new_username] - unique identifier of user
      # opts[:email] - email of user
      # opts[:email_verified]
      # opts[:phone_number] - email of user
      # opts[:phone_number_verified]
      # opts[:password] - new password of user
      def update_attributes!(opts = {})
        set_cognito(opts)
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
          @client.admin_update_user_attributes(
            {
              user_pool_id: @user_pool_id, # required
              username: username, # required
              user_attributes: user_attributes
            }
          )
        end

        if new_password.present?
          @client.admin_set_user_password(
            {
              user_pool_id: @user_pool_id,
              username: username,
              password: new_password,
              permanent: true
            }
          )
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
          sign_up_resp = @client.sign_up(sign_up_params)
          user_sub = sign_up_resp.user_sub
          confirm_sign_up!(username)
          user_sub
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
        begin
          initiate_auth!(opts).authentication_result
        rescue Aws::CognitoIdentityProvider::Errors::ServiceError => e
          raise e
        end
      end

      def sign_in_with_challenge!(opts = {})
        initiate_auth!(opts)
      end

      def respond_to_auth_challenge!(opts = {})
        set_cognito(opts)
        challenge_name = opts[:challenge_name].to_s
        challenge_responses = challenge_responses_for(challenge_name, opts)
        add_secret_hash!(challenge_responses, opts[:username])

        params = {
          user_pool_id: @user_pool_id,
          client_id: @client_id,
          challenge_name: challenge_name,
          session: opts[:session],
          challenge_responses: challenge_responses
        }
        params[:client_metadata] = opts[:client_metadata] if opts[:client_metadata].present?

        resp = @client.admin_respond_to_auth_challenge(params)
        resp.authentication_result || resp
      end

      def custom_challenge_auth!(opts = {}, &block)
        resp = sign_in_with_challenge!(opts.merge(auth_flow: "CUSTOM_AUTH"))
        raise "Unexpected Cognito custom auth challenge" unless resp.challenge_name.to_s == "CUSTOM_CHALLENGE"

        answer = block_given? ? yield(resp, @client_id) : opts[:answer]
        raise "Custom challenge answer is missing" if answer.blank?

        respond_to_auth_challenge!(
          opts.merge(
            challenge_name: "CUSTOM_CHALLENGE",
            session: resp.session,
            answer: answer
          )
        )
      end

      def associate_software_token!(opts = {})
        set_cognito(opts)
        params = software_token_session_params(opts)
        @client.associate_software_token(params)
      end

      def verify_software_token!(opts = {})
        set_cognito(opts)
        params = software_token_session_params(opts)
        params[:user_code] = opts[:user_code] || opts[:code]
        params[:friendly_device_name] = opts[:friendly_device_name] if opts[:friendly_device_name].present?
        @client.verify_software_token(params)
      end

      def admin_set_user_mfa_preference!(opts = {})
        set_cognito(opts)
        params = {
          user_pool_id: @user_pool_id,
          username: opts[:username],
          sms_mfa_settings: mfa_settings(opts, :sms_mfa),
          software_token_mfa_settings: mfa_settings(opts, :software_token_mfa)
        }.compact
        @client.admin_set_user_mfa_preference(params)
      end

      def disable_user_mfa!(opts = {})
        admin_set_user_mfa_preference!(
          opts.merge(
            sms_mfa_enabled: false,
            sms_mfa_preferred: false,
            software_token_mfa_enabled: false,
            software_token_mfa_preferred: false
          )
        )
      end

      def admin_get_user!(opts = {})
        set_cognito(opts)
        @client.admin_get_user(user_pool_id: @user_pool_id, username: opts[:username])
      end

      def delete_user! opts = {}
        set_cognito(opts)
        @client.admin_delete_user(user_pool_id: @user_pool_id, username: opts[:username]) rescue nil
      end

      def user_exists? opts = {}
        set_cognito(opts)
        @client.admin_get_user(user_pool_id: @user_pool_id, username: opts[:username]).present? rescue false
      end

      def verify_token(token, client_key: nil)
        payload = JWT.decode(token, nil, false).first rescue nil
        return false unless payload.present?

        iss = payload['iss']
        match = iss.match(/https:\/\/cognito-idp\.(.*?)\.amazonaws\.com\/(.*)/)
        sub = payload['sub']

        return false unless match.present?

        pool_id = match[2]

        mappings = Neucore.configuration.cognito_fields_mapping
        model, mapping = mappings.select { |_, m| m[:user_pool_id] == pool_id }.first
        return false unless mapping
        return false unless token_client_matches?(payload, mapping, client_key)

        region = mapping[:region]
        id_field = mapping[:id_field]
        model = model.to_s

        cont = model.classify.constantize rescue nil
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

      def token_client_matches?(payload, mapping, client_key)
        return true if client_key.nil? || client_key == ""

        expected_client_id = mapping[client_key.to_sym] || mapping[client_key.to_s]
        return false if expected_client_id.blank?

        token_client_id = payload["aud"]
        token_client_id = payload["client_id"] if token_client_id.nil? || token_client_id == ""
        token_client_id == expected_client_id
      end

      def fetch_jwks(url)
        resp_body = Rails.cache.fetch("COGNITO-JWKS", expires_in: 60.seconds) do
          conn = Faraday.new do |faraday|
            faraday.adapter Faraday.default_adapter
            faraday.ssl.verify = true
          end

          retry_count = 0
          resp = nil
          while(retry_count < 5) do 
            begin
              resp = conn.get(url) do |req|
                req.options.timeout = 10
              end
              break
            rescue
              retry_count += 1
            end
          end

          if resp.nil?
            Rails.cache.delete("COGNITO-JWKS")
            resp_body = nil
          else
            resp_body = resp.body
          end
        end

        JSON.parse(resp_body, symbolize_names: true)[:keys]
      end

      def revoke_token token
        set_cognito
        r = @client.revoke_token(token: token, client_id: @client_id)
        r
      end

      def list_users
        model = "user"
        mapping = Neucore.configuration.cognito_fields_mapping[model]

        client = Aws::CognitoIdentityProvider::Client.new(
          region: mapping[:region],
          access_key_id: Neucore.configuration.aws_access_key_id,
          secret_access_key: Neucore.configuration.aws_secret_access_key
        )

        # r = client.list_users(user_pool_id: mapping[:user_pool_id])
        r = client.admin_get_user(user_pool_id: mapping[:user_pool_id], username: '+8610000000000')
        r = client.admin_delete_user(user_pool_id: mapping[:user_pool_id], username: '+8619980000100')
      end

      private

      def initiate_auth!(opts = {})
        set_cognito(opts)
        auth_flow = opts[:auth_flow] || 'ADMIN_USER_PASSWORD_AUTH'
        auth_parameters = {}
        case auth_flow
        when 'ADMIN_USER_PASSWORD_AUTH'
          auth_parameters = {
            "USERNAME" => opts[:username],
            "PASSWORD" => opts[:password]
          }
        when "CUSTOM_AUTH"
          auth_parameters = {
            "CHALLENGE_NAME" => opts[:challenge_name] || "CUSTOM_CHALLENGE",
            "USERNAME" => opts[:username],
          }
        when "REFRESH_TOKEN"
          auth_parameters = {
            "REFRESH_TOKEN" => opts[:refresh_token]
          }
        end
        add_secret_hash!(auth_parameters, opts[:username]) if opts[:username].present?

        params = {
          auth_flow: auth_flow,
          user_pool_id: @user_pool_id,
          client_id: @client_id,
          auth_parameters: auth_parameters
        }
        params[:client_metadata] = opts[:client_metadata] if opts[:client_metadata].present?

        @client.admin_initiate_auth(params)
      end

      def challenge_responses_for(challenge_name, opts)
        responses = { "USERNAME" => opts[:username] }
        case challenge_name
        when "SOFTWARE_TOKEN_MFA"
          responses["SOFTWARE_TOKEN_MFA_CODE"] = opts[:code] || opts[:software_token_mfa_code]
        when "SMS_MFA"
          responses["SMS_MFA_CODE"] = opts[:code] || opts[:sms_mfa_code]
        when "MFA_SETUP"
          # Cognito expects the session returned by VerifySoftwareToken.
        when "SELECT_MFA_TYPE"
          responses["ANSWER"] = opts[:answer] || "SOFTWARE_TOKEN_MFA"
        when "CUSTOM_CHALLENGE"
          responses["ANSWER"] = opts[:answer]
        when "NEW_PASSWORD_REQUIRED"
          responses["NEW_PASSWORD"] = opts[:new_password]
        end
        responses.compact
      end

      def software_token_session_params(opts)
        if opts[:access_token].present?
          { access_token: opts[:access_token] }
        else
          { session: opts[:session] }
        end
      end

      def mfa_settings(opts, prefix)
        enabled_key = "#{prefix}_enabled".to_sym
        preferred_key = "#{prefix}_preferred".to_sym
        return nil unless opts.key?(enabled_key) || opts.key?(preferred_key)

        {
          enabled: opts[enabled_key],
          preferred_mfa: opts[preferred_key]
        }.compact
      end

      def add_secret_hash!(params, username)
        return params if @client_secret.blank? || username.blank?

        digest = OpenSSL::HMAC.digest("sha256", @client_secret, "#{username}#{@client_id}")
        params["SECRET_HASH"] = Base64.strict_encode64(digest)
        params
      end
    end
  end
end
