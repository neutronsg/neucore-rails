# frozen_string_literal: true

require_relative "neucore/version"

require "neucore/configuration"
require "neucore/jwt_token_issuer"       # Adjust based on your actual token generation file
require "neucore/jwt_token_authenticator" # Make sure this matches the new file/module name
require "neucore/engine"

module Neucore
  class Error < StandardError; end
  # Your code goes here...
end
