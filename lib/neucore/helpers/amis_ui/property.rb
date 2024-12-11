module Neucore
  module Helpers
    module AmisUi
      module Property
        def amis_text_property options = {}
          schema = options.slice(:label, :span, :content)
          
          schema
        end

        def amis_number_property options = {}
          schema = options.slice(:label, :span)
          schema[:content] = {
            type: 'tpl',
            tpl: "${ '#{options[:content]}' }"
          }
          
          schema
        end

        def amis_ml_property options = {}
          model = options.delete(:model)
          property = options.delete(:property)
          content_ml = options[:content_ml]
          schemas = []
          I18n.ml_locales.each do |locale|
            schemas << amis_text_property(options).merge(
              label: model.human_attribute_name("#{property}_#{locale}"),
              content: content_ml[locale]
            )
          end

          schemas
        end

        def amis_richtext_property options = {}
          schema = options.slice(:label, :span)
          schema[:content] = options[:content]
          schema
        end

        def amis_boolean_property options = {}
          schema = options.slice(:label, :span)
          schema[:content] = {
            type: 'tag',
            displayMode: 'normal',
            label: options[:content] ? 'True' : 'False'
          }

          schema
        end

        def amis_image_property options = {}
          schema = options.slice(:label, :span)
          schema[:content] = {
            type: 'image',
            src: options[:content],
            enlargeAble: options[:enlargeAble].nil? ? true : options[:enlargeAble]
          }
          
          schema
        end

        def amis_video_property options = {}
          schema = options.slice(:label, :span)
          schema[:content] = {
            type: 'video',
            src: options[:content]
          }

          schema
        end

        def amis_images_property options = {}
          schema = options.slice(:label, :span)
          schema[:content] = {
            type: 'images',
            options: options[:content],
            enlargeAble: options[:enlargeAble].nil? ? true : options[:enlargeAble] # 预览
          }
          
          schema
        end

        def amis_datetime_property options = {}
          schema = options.slice(:label, :span)
          schema[:content] = {
            type: 'tpl',
            tpl: "${ DATETOSTR('#{options[:content]}') }"
          }

          schema
        end

        def amis_date_property options = {}
          schema = options.slice(:label, :span)
          schema[:content] = {
            type: 'tpl',
            tpl: "${ DATETOSTR('#{options[:content]}', 'YYYY-MM-DD') }"
          }
          
          schema
        end

        def amis_link_property options = {}
          schema = options.slice(:label, :span)
          schema[:content] = {
            type: 'button',
            level: 'link',
            actionType: 'link',
            label: options[:content][:label],
            link: "/#{options[:content][:resource]}/#{options[:content][:id]}"
          } if options[:content].present?
          
          schema
        end

        def amis_links_property options = {}
          schema = options.slice(:label, :span)
          schema[:content] = {
            type: 'each',
            value: options[:content],
            placeholder: '-',
            items: {
              type: 'button',
              level: 'link',
              actionType: 'link',
              label: "${item.label}",
              link: "/${item.resource}/${item.id}",
            }
          }

          schema
        end
      end
    end
  end
end


