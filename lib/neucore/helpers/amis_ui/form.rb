module Neucore
  module Helpers
    module AmisUi
      module Form
        def amis_form_text options = {}
          schema = options
          schema[:type] ||= 'input-text'
          schema[:trimContents] = true if schema[:trimContents].nil?
          schema[:clearValueOnHidden] = true if schema[:clearValueOnHidden].nil?
          schema[:labelAlign] = 'left'
          schema
        end

        def amis_form_tag options = {}
          schema = options
          schema[:type] ||= 'input-tag'
          schema[:enableBatchAdd] = true if schema[:enableBatchAdd].nil?
          schema[:joinValues] = false if schema[:joinValues].nil?
          schema[:extractValue] = true if schema[:extractValue].nil?
          schema
        end

        def amis_form_richtext options = {}
          schema = options
          schema[:type] ||= 'input-rich-text'
          schema[:trimContents] = true if schema[:trimContents].nil?
          schema[:clearValueOnHidden] = true if schema[:clearValueOnHidden].nil?
          schema[:labelAlign] = 'left'
          schema[:receiver] ||= 'cms/images'
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

        def amis_form_richml options = {}
          schemas = []
          name = options.delete(:name)
          model = options.delete(:model)

          I18n.ml_locales.each do |locale|
            schemas << amis_form_richtext(options).merge(name: "#{name}_ml.#{locale}", label: model.human_attribute_name("#{name}_#{locale}"), labelAlign: 'left')
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
          schema[:joinValues] = false if schema[:joinValues].nil?
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
          schema[:joinValues] = false if schema[:joinValues].nil?
          schema[:multiple] = true if schema[:multiple].nil?
          schema[:maxSize] ||= "10m"
          schema[:maxLength] ||= 10 * 1024 * 1024
          schema[:draggable] = true if schema[:draggable].nil?

          schema
        end

        def amis_form_videos options = {}
          schema = options
          schema[:name] ||= 'videos'
          schema[:label] ||= I18n.t('videos', default: 'Videos')
          schema[:labelAlign] = 'left'
          schema[:type] ||= 'input-file'
          schema[:receiver] ||= 'cms/images'
          schema[:joinValues] = false if schema[:joinValues].nil?
          schema[:multiple] = true if schema[:multiple].nil?
          schema[:maxLength] ||= 5
          schema[:useChunk] = false if schema[:useChunk].nil?
          schema[:accept] = '.mp4'
          schema[:maxSize] ||= 200 * 1024 * 1024
          
          schema
        end

        def amis_form_files options = {}
          schema = options
          schema[:name] ||= 'files'
          schema[:label] ||= I18n.t('files', default: 'Files')
          schema[:labelAlign] = 'left'
          schema[:type] ||= 'input-file'
          schema[:receiver] ||= 'cms/images'
          schema[:joinValues] = false if schema[:joinValues].nil?
          schema[:multiple] = true if schema[:multiple].nil?
          schema[:maxLength] ||= 5
          schema[:useChunk] = false if schema[:useChunk].nil?
          schema[:accept] = options[:accept]
          schema[:maxSize] ||= 200 * 1024 * 1024
          
          schema
        end

        def amis_form_switch options = {}
          schema = options
          schema[:type] ||= 'switch'
          schema[:labelAlign] = 'left'
          schema[:clearValueOnHidden] = true if schema[:clearValueOnHidden].nil?
          
          schema
        end

        def amis_form_checkbox options = {}
          schema = options
          schema[:type] ||= 'checkbox'
          schema[:labelAlign] = 'left'
          schema[:clearValueOnHidden] = true if schema[:clearValueOnHidden].nil?
          
          schema
        end

        def amis_form_checkboxes options = {}
          schema = options
          schema[:type] ||= 'checkboxes'
          schema[:labelAlign] = 'left'
          schema[:joinValues] = false if schema[:joinValues].nil?
          schema[:extractValue] = true if schema[:extractValue].nil?
          schema[:checkAll] = true if schema[:checkAll].nil?
          schema[:clearValueOnHidden] = true if schema[:clearValueOnHidden].nil?
          
          schema
        end

        def amis_form_select options = {}
          schema = options
          schema[:type] ||= 'select'
          schema[:labelAlign] = 'left'
          schema[:joinValues] = false if schema[:joinValues].nil?
          schema[:extractValue] = true if schema[:extractValue].nil?
          schema[:clearValueOnHidden] = true if schema[:clearValueOnHidden].nil?
          schema[:clearable] = true if schema[:clearable].nil?
          schema[:searchable] = true if schema[:searchable].nil?
          
          schema
        end

        def amis_form_tree_select options = {}
          schema = options
          schema[:type] ||= 'tree-select'
          schema[:labelAlign] = 'left'
          schema[:joinValues] = false if schema[:joinValues].nil?
          schema[:extractValue] = true if schema[:extractValue].nil?
          schema[:clearValueOnHidden] = true if schema[:clearValueOnHidden].nil?
          schema[:clearable] = true if schema[:clearable].nil?
          
          schema
        end

        def amis_form_radios options = {}
          schema = options
          schema[:type] ||= 'radios'
          schema[:labelAlign] = 'left'
          schema[:clearValueOnHidden] = true if schema[:clearValueOnHidden].nil?
          
          schema
        end

        def amis_form_table options = {}
          schema = options
          schema[:type] = 'input-table'
          schema[:needConfirm] = false if schema[:needConfirm].nil?
          schema[:removable] = true if schema[:removable].nil?
          schema[:addable] = true if schema[:addable].nil?
        
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
