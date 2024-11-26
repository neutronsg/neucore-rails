require_relative 'amis_ui/crud'
require_relative 'amis_ui/base'
require_relative 'amis_ui/form'
require_relative 'amis_ui/button'
require_relative 'amis_ui/property'

module Neucore
  module Helpers
    module AmisUi
      include Base
      include Crud
      include Button
      include Property
      include Form

      def amis_searchable filter
        schema = {
          type: 'input-text',
          name: "#{filter}_cont",
          label: filter,
          placeholder: filter
        }
        
        schema
      end

      def amis_custom_clickable object
        return unless object
        {
          resource: object.class.name.tableize,
          label: object&.display_name || object&.id,
          id: object.id
        }
      end

      def amis_custom_clickables objects
        return unless objects
        objects.map do |object|
          {
            resource: object.class.name.tableize,
            label: object&.display_name || object&.id,
            id: object.id
          }
        end
      end

      def amis_select_options model
        model.constantize.all.collect{|r| {label: r.name, value: r.id}}
      end
    end
  end
end






