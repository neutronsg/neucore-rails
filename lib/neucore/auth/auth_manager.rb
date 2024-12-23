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
      # opts[:password] - the user's password
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

      # @param opts [Hash] - options for authentication
      # opts[:model] - the model to authenticate (e.g., :user, :admin)
      # opts[:refresh_token] - the unique field used for login (e.g., :email, :username)
      def refresh_token!(opts = {})
        case Neucore.configuration.auth_strategy
        when :in_house
          # pass first
        when :cognito
          CognitoAuthService.refresh_token!(opts)
        else
          raise Neucore::AuthStrategyError, "Auth Strategy not set"
        end
      end
    end
  end
end
