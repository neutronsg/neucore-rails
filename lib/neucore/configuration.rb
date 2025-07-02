module Neucore

  class Configuration
    DEFAULT_JWT_EXPIRY_TIME = 7.days.to_i
    DEFAULT_JWT_SECRET_KEY = "default_secret_key_change_this" # Replace with a more secure fallback or random key
    DEFAULT_ISSUER_NAME = "Neucore"
    DEFAULT_AUTH_STRATEGY = :in_house
    DEFAULT_CMS_PATH = 'cms'

    attr_accessor :jwt_secret_key, :jwt_expiry_time, :jwt_issuer, :auth_strategy,
                  :cognito_fields_mapping, :aws_access_key_id, :aws_secret_access_key,
                  :cms_path

    def initialize
      # Set defaults if no custom values are provided in the initializer
      @jwt_secret_key = DEFAULT_JWT_SECRET_KEY
      @jwt_expiry_time = DEFAULT_JWT_EXPIRY_TIME
      @jwt_issuer = DEFAULT_ISSUER_NAME
      @auth_strategy = DEFAULT_AUTH_STRATEGY
      # Array of hashes
      # {model: "User", user_pool_id: "abc", client_id: "client_id", region: "ap-southeast-1"}
      @cognito_fields_mapping = []
      @cms_path = DEFAULT_CMS_PATH
    end
  end

  class << self
    attr_accessor :configuration

    def configuration
      @configuration ||= Configuration.new
    end
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

end
