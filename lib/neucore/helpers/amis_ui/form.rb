module Neucore
  module Helpers
    module AmisUi
      module Form
        def amis_form_text options = {}
          schema = options
          schema[:type] ||= 'input-text'
          schema[:trimContents] = true
          schema[:clearValueOnHidden] = true
          
          schema
        end

        def amis_form_ml options = {}
          schemas = []
          name = options.delete(:name)
          model = options.delete(:model)

          I18n.ml_locales.each do |locale|
            schemas << amis_form_text(options).merge(name: "#{name}_ml.#{locale}", label: model.human_attribute_name("#{name}_#{locale}"))
          end

          schemas
        end

        def amis_form_switch options = {}
          schema = options
          schema[:type] ||= 'switch'
          schema[:clearValueOnHidden] = true
          
          schema
        end

        def amis_form_checkbox options = {}
          schema = options
          schema[:type] ||= 'checkbox'
          schema[:clearValueOnHidden] = true
          
          schema
        end

        def amis_form_checkboxes options = {}
          schema = options
          schema[:type] ||= 'checkboxes'
          schema[:joinValues] = false
          schema[:extractValue] = true
          schema[:checkAll] = true
          schema[:clearValueOnHidden] = true
          
          schema
        end

        def amis_form_select options = {}
          schema = options
          schema[:type] ||= 'select'
          schema[:joinValues] = false
          schema[:extractValue] = true
          schema[:clearValueOnHidden] = true
          
          schema
        end

        def amis_form_radios options = {}
          schema = options
          schema[:type] ||= 'radios'
          schema[:clearValueOnHidden] = true
          
          schema
        end
      end
    end
  end
end
