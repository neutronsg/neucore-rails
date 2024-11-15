module Neucore
  module Helpers
    module AmisUi
      module Column
        def amis_id_column options = {}
          schema = {
            name: 'id',
            label: 'ID',
            fixed: 'left'
          }.merge(options)

          schema
        end

        def amis_string_column model = nil, field = nil, options = {}
          schema = {
            name: field,
            label: model.human_attribute_name(field)
          }.merge(options)
          
          schema
        end
      end
    end
  end
end
