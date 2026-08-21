module Neucore
  class AuthManager

    class << self
      # @param opts [Hash] - options for authentication
      # opts[:model] - the model to authenticate (e.g., :user, :admin)
      # opts[:login] - the unique field used for login (e.g., :email, :username)
      # opts[:email] - email of the user (optional)
      # opts[:username] - the value of the unique field
      # opts[:password] - the user's password
      # opts[:auto_sign_in] - whether to automatically sign in user after sign up
      # @return
      # if auto_sign_in is present, access_token and refresh_token is returned
      # else truthy value will be returned
      # raise if sign up failed
      def sign_up!(opts = {})
        case Neucore.configuration.auth_strategy
        when :in_house
          InHouseAuthService.sign_up!(opts)
        when :cognito
          CognitoAuthService.sign_up!(opts)
        else
          raise Neucore::AuthStrategyError, "Auth Strategy not set"
        end
      end

      # @param opts [Hash] - options for authentication
      # opts[:model] - the model to authenticate (e.g., :user, :admin)
      # opts[:login] - the unique field used for login (e.g., :email, :username)
      # opts[:username] - the value of the unique field
      # opts[:password] - the user's password, required if auth_flow != CUSTOM_AUTH
      # opts[:auth_flow] - Cognito only
      #  - if CUSTOM_AUTH: Force Sign In
      #  - else username & password
      def sign_in!(opts = {})
        case Neucore.configuration.auth_strategy
        when :in_house
          InHouseAuthService.sign_in!(opts)
        when :cognito
          CognitoAuthService.sign_in!(opts)
        else
          raise Neucore::AuthStrategyError, "Auth Strategy not set"
        end
      end

      def sign_in_with_challenge!(opts = {})
        cognito_only(:sign_in_with_challenge!, opts)
      end

      # @param opts [Hash] - options for authentication
      # opts[:model] - the model to authenticate (e.g., :user, :admin)
      # opts[:refresh_token] - refresh token
      def refresh_token!(opts = {})
        case Neucore.configuration.auth_strategy
        when :in_house
          # pass first
        when :cognito
          CognitoAuthService.sign_in!(opts)
        else
          raise Neucore::AuthStrategyError, "Auth Strategy not set"
        end
      end

      # @param opts [Hash] - options for authentication
      # opts[:model] - the model to authenticate (e.g., :user, :admin)
      # opts[:model] - the model to authenticate (e.g., :user, :admin)
      # opts[:username] - unique identifier of user
      # opts[:email] - email of user
      # opts[:email_verified]
      # opts[:phone_number] - email of user
      # opts[:phone_number_verified]
      # opts[:password] - new password of user
      def update_user_attributes!(opts = {})
        case Neucore.configuration.auth_strategy
        when :in_house
          # pass first
        when :cognito
          CognitoAuthService.update_attributes!(opts)
        else
          raise Neucore::AuthStrategyError, "Auth Strategy not set"
        end
      end

      def delete_user! opts = {}
        case Neucore.configuration.auth_strategy
        when :in_house
          # pass first
        when :cognito
          CognitoAuthService.delete_user!(opts)
        else
          raise Neucore::AuthStrategyError, "Auth Strategy not set"
        end
      end

      def user_exists? opts = {}
        case Neucore.configuration.auth_strategy
        when :in_house
          # pass first
        when :cognito
          CognitoAuthService.user_exists?(opts)
        else
          raise Neucore::AuthStrategyError, "Auth Strategy not set"
        end
      end

      def respond_to_auth_challenge!(opts = {})
        cognito_only(:respond_to_auth_challenge!, opts)
      end

      def associate_software_token!(opts = {})
        cognito_only(:associate_software_token!, opts)
      end

      def verify_software_token!(opts = {})
        cognito_only(:verify_software_token!, opts)
      end

      def admin_set_user_mfa_preference!(opts = {})
        cognito_only(:admin_set_user_mfa_preference!, opts)
      end

      def disable_user_mfa!(opts = {})
        cognito_only(:disable_user_mfa!, opts)
      end

      def admin_get_user!(opts = {})
        cognito_only(:admin_get_user!, opts)
      end

      private

      def cognito_only(method_name, opts)
        case Neucore.configuration.auth_strategy
        when :in_house
          # pass first
        when :cognito
          CognitoAuthService.public_send(method_name, opts)
        else
          raise Neucore::AuthStrategyError, "Auth Strategy not set"
        end
      end
    end
  end
end
