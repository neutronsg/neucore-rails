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
        {
          resource: object.class.name.tableize,
          label: object&.display_name || object&.id,
          id: object.id
        }
      end
    end
  end
end






