module Neucore
  module Helpers
    module AmisUi
      module Form
        def amis_form_text options = {}
          schema = options
          schema[:type] ||= 'input-text'
          
          schema
        end

        def amis_form_switch options = {}
          schema = options
          schema[:type] ||= 'switch'
          
          schema
        end

        def amis_form_checkbox options = {}
          schema = options
          schema[:type] ||= 'checkbox'
          
          schema
        end

        def amis_form_select options = {}
          schema = options
          schema[:type] ||= 'select'
          
          schema
        end

        def amis_form_radios options = {}
          schema = options
          schema[:type] ||= 'radios'
          
          schema
        end
      end
    end
  end
end
