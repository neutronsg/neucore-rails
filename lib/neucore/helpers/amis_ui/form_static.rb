module Neucore
  module Helpers
    module AmisUi
      module FormStatic
        def amis_static_text options = {}
          schema = options
          schema[:type] ||= 'static'
          schema
        end

        def amis_static_ml_text options = {}
          schemas = []
          property = options.delete(:property)
          model = options.delete(:model)
          value_ml = options.delete(:value_ml)

          I18n.ml_locales.each do |locale|
            schemas << amis_static_text(options).merge(
              label: model.human_attribute_name("#{property}_#{locale}"),
              value: value_ml[locale]
            )
          end

          schemas
        end

        def amis_static_rating options = {}
          schema = options
          schema[:count] ||= 5
          schema[:type] = 'input-rating'
          schema[:readOnly] = true
          schema
        end

        def amis_static_link options = {}
          return {
            type: 'static',
            label: options[:label]
          } if options[:link].nil?

          schema = options
          schema[:type] ||= 'static-link'
          schema[:body] = options.dig(:link, :label)
          schema[:href] = "/#{options.dig(:link, :resource)}/#{options.dig(:link, :id)}"
          schema.delete(:link)

          schema
        end

        def amis_static_html options = {}
          schema = options
          schema[:type] ||= 'static-html'
          schema
        end

        def amis_static_datetime options = {}
          schema = options
          schema[:type] ||= 'static-datetime'
          schema[:value] = schema[:value].to_i

          schema
        end

        def amis_static_image options = {}
          schema = options
          schema[:type] ||= 'static-image'
          schema[:originalSrc] = schema[:value]

          schema
        end

        def amis_static_images options = {}
          schema = options
          schema[:type] ||= 'static-images'
          schema[:enlargeAble] = true
          schema[:originalSrc] = schema[:value]

          schema
        end

        def amis_static_video options = {}
          schema = options
          schema[:type] ||= 'static-video'
          schema[:style] = {width: 500}
          schema
        end
      end
    end
  end
end
