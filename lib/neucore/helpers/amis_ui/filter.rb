module Neucore
  module Helpers
    module AmisUi
      module Filter
        def amis_text_filter options = {}
          name = options.delete(:name)
          schema = options
          schema[:name] = "#{name}_cont"
          schema[:type] ||= 'input-text'
          schema[:label] ||= false
          placeholder = I18n.t("filters.#{name}", default: name.titleize)
          placeholder = "${CAPITALIZE('content')}" if placeholder == 'Content'
          schema[:placeholder] ||= placeholder
          
          schema
        end

        def amis_ml_text_filter options = {}
          name = options.delete(:name)
          schema = options
          schema[:name] = "#{name}_ml_cont"
          schema[:type] ||= 'input-text'
          schema[:label] ||= false
          placeholder = I18n.t("filters.#{name}", default: name.titleize)
          placeholder = "${CAPITALIZE('content')}" if placeholder == 'Content'
          schema[:placeholder] ||= placeholder

          schema
        end

        def amis_enum_filter options = {}
          name = options.delete(:name)
          schema = options
          schema[:name] = "#{name}_eq"
          schema[:type] ||= 'select'
          schema[:label] ||= false
          schema[:clearable] = true if schema[:clearable].nil?
          schema[:searchable] = true if schema[:searchable].nil? && schema[:options].length > 6
          schema[:placeholder] ||= I18n.t("filters.#{name}", default: name.titleize)

          schema
        end

        def amis_array_filter options = {}
          name = options.delete(:name)
          schema = options
          schema[:name] = "#{name}_contains_array"
          schema[:type] ||= 'select'
          schema[:label] ||= false
          schema[:joinValues] = true if schema[:joinValues].nil?
          schema[:extractValue] = true if schema[:extractValue].nil?
          schema[:clearable] = true if schema[:clearable].nil?
          schema[:searchable] = true if schema[:searchable].nil? && schema[:options].length > 6
          schema[:placeholder] ||= I18n.t("filters.#{name}", default: name.titleize)

          schema
        end

        def amis_boolean_filter options = {}
          name = options.delete(:name)
          schema = options
          schema[:name] = "#{name}_eq"
          schema[:type] ||= 'select'
          schema[:label] ||= false
          schema[:clearable] = true if schema[:clearable].nil?
          schema[:placeholder] ||= I18n.t("filters.#{name}", default: name.titleize)
          schema[:options] = [
            {label: 'YES', value: true},
            {label: 'NO', value: false}
          ]
          schema
        end

        def amis_daterange_filter options = {}
          name = options.delete(:name)
          schema = options
          schema[:name] = "#{name}_between"
          schema[:type] ||= 'input-date-range'
          schema[:valueFormat] ||= "YYYYMMDD"
          schema[:delimiter] = 'to'
          schema[:label] ||= false
          schema[:placeholder] ||= I18n.t("filters.#{name}", default: name.titleize)

          schema
        end

        def amis_enum_filter_options model, enums
          model.classify.constantize.send(enums).collect{|enum, value| { label: I18n.t("enums.#{model}.#{enums}.#{enum}", default: enum.titleize), value: value }}
        end
      end
    end
  end
end






