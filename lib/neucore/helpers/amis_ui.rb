require_relative 'amis_ui/crud'
require_relative 'amis_ui/base'
require_relative 'amis_ui/form'
require_relative 'amis_ui/form_static'
require_relative 'amis_ui/button'
require_relative 'amis_ui/property'
require_relative 'amis_ui/filter'

module Neucore
  module Helpers
    module AmisUi
      include Base
      include Crud
      include Button
      include Property
      include Form
      include FormStatic
      include Filter

      def amis_custom_clickable object, options = {}
        return unless object
        {
          resource: options[:resource] || object.class.name.tableize,
          label: options[:label] || object&.display_name || object&.id,
          id: object.id
        }
      end

      def amis_custom_clickables objects, options = {}
        return unless objects
        objects.map do |object|
          {
            resource: options[:resource] || object.class.name.tableize,
            label: options[:label] || object&.display_name || object&.id,
            id: object.id
          }
        end
      end

      def amis_select_options model
        model.constantize.all.collect{|r| {label: r.name, value: r.id}}
      end

      def amis_enum_options model, enums
        model.classify.constantize.send(enums).keys.collect{|enum| { label: I18n.t("enums.#{model}.#{enums}.#{enum}", default: enum.titleize), value: enum }}
      end

      def amis_array_options values
        values.collect{|value| {label: value, value: value}}
      end

      def amis_escape_obj(obj)
        case obj
        when String
          obj.gsub('$', '\\$')
        when Hash
          obj.each_with_object({}) do |(k, v), r|
            r[k] = amis_escape_obj(v)
          end
        when Array
          obj.map { |x| amis_escape_obj(x) }
        else
          obj
        end
      end
    end
  end
end






