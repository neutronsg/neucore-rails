require 'active_support/concern'
require 'active_support/core_ext/array'
require 'active_model/naming'
require 'active_model/translation'
require 'active_record/type'
require 'active_record/enum'
module Neucore::Enumable
  extend ActiveSupport::Concern
  included do
    def human_enum_value(enum_name)
      enum_value = send enum_name
      self.class.human_enum_value(enum_name, enum_value) unless enum_value.nil?
    end
  end

  class_methods do
    # def enum1(definitions)
    #   if RUBY_VERSION.first.to_i >= 3
    #     super nil, nil, **definitions
    #   else
    #     super definitions
    #   end

    #   definitions.keys.without(:_prefix, :_suffix).each do |name|
    #     human_enum name
    #   end
    # end

    def enum(enum_name, definitions, **options)
      super enum_name, definitions, **options
      human_enum enum_name
      # definitions.keys.without(:_prefix, :_suffix).each do |name|
      #   human_enum name
      # end
    end

    def human_enum_value(enum_name, enum_value)
      attributes_scope = "enums"
      enum_key = "#{enum_name.to_s.pluralize}.#{enum_value}"

      defaults = lookup_ancestors.map do |klass|
        :"#{attributes_scope}.#{klass.model_name.i18n_key}.#{enum_key}"
      end

      defaults << :"attributes.#{enum_key}"
      defaults << enum_value.to_s.titleize

      I18n.translate defaults.shift, default: defaults
    end

    def human_enum(enum_name)
      send :define_method, "human_#{enum_name}" do
        human_enum_value enum_name
      end

      collection_name = enum_name.to_s.pluralize
      self.class.send :define_method, "human_#{collection_name}" do
        human_enum_value enum_name, nil
      end
    end
  end
end
