module Neucore
  module Helpers
    module AmisUi
      module Form
        def amis_form_text options = {}
          schema = options
          schema[:type] ||= 'input-text'
          schema[:trimContents] = true
          schema[:clearValueOnHidden] = true
          schema[:labelAlign] = 'left'
          schema
        end

        def amis_form_ml options = {}
          schemas = []
          name = options.delete(:name)
          model = options.delete(:model)

          I18n.ml_locales.each do |locale|
            schemas << amis_form_text(options).merge(name: "#{name}_ml.#{locale}", label: model.human_attribute_name("#{name}_#{locale}"), labelAlign: 'left')
          end

          schemas
        end

        def amis_form_image options = {}
          schema = options
          schema[:name] ||= 'image'
          schema[:label] ||= I18n.t('image', default: 'Image')
          schema[:labelAlign] = 'left'
          schema[:type] ||= 'input-image'
          schema[:receiver] ||= 'cms/images'
          schema[:joinValues] = false
          schema[:maxSize] ||= 10 * 1024 * 1024

          schema
        end

        def amis_form_images options = {}
          schema = options
          schema[:name] ||= 'images'
          schema[:label] ||= I18n.t('images', default: 'Images')
          schema[:labelAlign] = 'left'
          schema[:type] ||= 'input-image'
          schema[:receiver] ||= 'cms/images'
          schema[:joinValues] = false
          schema[:multiple] = true
          schema[:maxSize] ||= "10m"
          schema[:maxLength] ||= 10 * 1024 * 1024
          schema[:draggable] = true

          schema
        end

        def amis_form_videos options = {}
          schema = options
          schema[:name] ||= 'videos'
          schema[:label] ||= I18n.t('videos', default: 'Videos')
          schema[:labelAlign] = 'left'
          schema[:type] ||= 'input-file'
          schema[:receiver] ||= 'cms/images'
          schema[:joinValues] = false
          schema[:multiple] = true
          schema[:maxLength] ||= 5
          schema[:useChunk] = false
          schema[:accept] = '.mp4'
          schema[:maxSize] ||= 200 * 1024 * 1024
          
          schema
        end

        def amis_form_switch options = {}
          schema = options
          schema[:type] ||= 'switch'
          schema[:labelAlign] = 'left'
          schema[:clearValueOnHidden] = true
          
          schema
        end

        def amis_form_checkbox options = {}
          schema = options
          schema[:type] ||= 'checkbox'
          schema[:labelAlign] = 'left'
          schema[:clearValueOnHidden] = true
          
          schema
        end

        def amis_form_checkboxes options = {}
          schema = options
          schema[:type] ||= 'checkboxes'
          schema[:labelAlign] = 'left'
          schema[:joinValues] = false
          schema[:extractValue] = true
          schema[:checkAll] = true
          schema[:clearValueOnHidden] = true
          
          schema
        end

        def amis_form_select options = {}
          schema = options
          schema[:type] ||= 'select'
          schema[:labelAlign] = 'left'
          schema[:joinValues] = false
          schema[:extractValue] = true
          schema[:clearValueOnHidden] = true
          schema[:clearable] = true
          
          schema
        end

        def amis_form_radios options = {}
          schema = options
          schema[:type] ||= 'radios'
          schema[:labelAlign] = 'left'
          schema[:clearValueOnHidden] = true
          
          schema
        end

        def amis_panel_actions
          schema = {
            type: 'flex',
            justify: 'flex-end',
            items: [
              {
                type: 'reset', label: I18n.t('reset'), size: 'lg'
              },
              {
                type: 'submit', label: I18n.t('submit'), size: 'lg', level: 'info', style: {'margin-left': 8}
              }
            ]
          }
        end
      end
    end
  end
end
