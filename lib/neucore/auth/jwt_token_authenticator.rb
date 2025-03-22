module Neucore
  module JwtTokenAuthenticator
    extend ActiveSupport::Concern

    module ClassMethods

      def jwt_token_auth(models = [])
        define_methods(models)
      end

      def define_methods(models)

        models.each do |model|
          class_eval <<-METHODS, __FILE__, __LINE__ + 1
          def token_authenticate_#{model}
            verify_token
          end

          def token_authenticate_#{model}!
            verify_token!
          end

          def current_#{model}
            @current_#{model}
          end

          def current_#{model}_id
            @current_#{model}&.id
          end

          # check that authenticate_user has successfully returned @current_jwt_token_resource (user is authenticated)
          def #{model}_signed_in?
            @current_#{model}.present?
          end

          METHODS
          ActiveSupport.on_load(:action_controller) do
            if respond_to?(:helper_method)
              helper_method "current_#{model}", "current_#{model}_id", "#{model}_signed_in?"
            end
          end
        end
      end
    end

    def access_token
      authorization = request.headers['Authorization']
      @access_token ||= authorization && authorization.split(' ').last
    end

    def verify_token!
      result = verify_token(access_token)
      raise Neucore::Unauthorized unless result
    end

    def verify_token
      token = access_token
      case Neucore.configuration.auth_strategy
      when :in_house
        resource, scp = InHouseAuthService.verify_token(token)
        return false unless resource.present?

        self.instance_variable_set("@current_#{scp}", resource)
      when :cognito
        resource, scp = CognitoAuthService.verify_token(token)
        return false unless resource.present?

        self.instance_variable_set("@current_#{scp}", resource)
      else
        false
      end
    end

  end
end