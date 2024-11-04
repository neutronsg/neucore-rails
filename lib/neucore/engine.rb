require 'rails'
require 'rails/all'

module Neucore
  class Engine < ::Rails::Engine
    isolate_namespace Neucore # Isolates Neucore routes, models, and controllers
  end
end