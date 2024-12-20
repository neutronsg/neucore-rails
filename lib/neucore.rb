# frozen_string_literal: true
require 'cancancan'
require 'paranoia'
require 'paper_trail'
require 'faraday'
require 'faraday/multipart'
require 'ransack'

require_relative "neucore/version"
require "neucore/engine"
require "neucore/configuration"
require "neucore/auth/auth_manager" # Adjust based on your actual token generation file
require "neucore/auth/cognito_auth_service" # Adjust based on your actual token generation file
require "neucore/auth/in_house_auth_service" # Adjust based on your actual token generation file
require "neucore/auth/jwt_token_authenticator" # Adjust based on your actual token generation file
require "neucore/auto_strip_attributes" # Make sure this matches the new file/module name
require "neucore/localeable" # Make sure this matches the new file/module name
require "neucore/enumable" # Make sure this matches the new file/module name
require "neucore/versionable" # Make sure this matches the new file/module name
require "neucore/helpers" # Make sure this matches the new file/module name
require "neucore/base_client" # Make sure this matches the new file/module name

module Neucore
  class Unauthorized < StandardError; end

  class AuthStrategyError < StandardError; end

  # Your code goes here...

  ActiveSupport.on_load(:action_view) do
    include Helpers
  end
end
