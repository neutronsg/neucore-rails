module Neucore
  module Helpers
    module AmisUi
      module Filter
        def amis_text_filter options = {}
          name = options.delete(:name)
          schema = options
          schema[:name] = "#{name}_cont"
          schema[:type] ||= 'input-text'
          schema[:label] ||= I18n.t("filters.#{name}", default: name.titleize)
          placeholder = I18n.t("filters.#{name}", default: name.titleize)
          placeholder = "${CAPITALIZE('content')}" if placeholder == 'Content'
          schema[:placeholder] ||= placeholder
          
          # schema[:placeholder] ||= I18n.t("filters.#{name}", default: name.titleize)

          schema
        end

        def amis_ml_text_filter options = {}
          name = options.delete(:name)
          schema = options
          schema[:name] = "#{name}_ml_cont"
          schema[:type] ||= 'input-text'
          schema[:label] ||= I18n.t("filters.#{name}", default: name.titleize)
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
          schema[:label] ||= I18n.t("filters.#{name}", default: name.titleize)
          schema[:placeholder] ||= ''

          schema
        end

        def amis_daterange_filter options = {}
          name = options.delete(:name)
          schema = options
          schema[:name] = "#{name}_between"
          schema[:type] ||= 'input-date-range'
          schema[:valueFormat] ||= "YYYYMMDD"
          schema[:delimiter] = 'to'
          schema[:label] ||= I18n.t("filters.#{name}", default: name.titleize)
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






