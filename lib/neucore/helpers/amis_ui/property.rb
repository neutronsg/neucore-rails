module Neucore
  module Helpers
    module AmisUi
      module Property
        def amis_text_property options = {}
          schema = options.slice(:label, :span, :content)
          schema
        end

        def amis_richtext_property options = {}
          schema = options.slice(:label, :span)
          schema[:content] = options[:content]
          schema
        end

        def amis_image_property options = {}
          schema = options.slice(:label, :span)
          schema[:content] = {
            type: 'image',
            src: options[:src],
            enlargeAble: options[:enlargeAble].nil? ? true : options[:enlargeAble]
          }
          
          schema
        end

        def amis_images_property options = {}
          schema = options.slice(:label, :span)
          schema[:content] = {
            type: 'images',
            options: options[:images],
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
            label: options[:name],
            link: options[:link]
          }
          
          schema
        end

        def amis_links_property options = {}
          schema = options.slice(:label, :span)
          schema[:content] = {
            type: 'each',
            value: options[:links],
            placeholder: '-',
            items: {
              type: 'button',
              level: 'link',
              actionType: 'link',
              label: "${item.name}",
              link: "${item.link}",
            }
          }

          schema
        end
      end
    end
  end
end


