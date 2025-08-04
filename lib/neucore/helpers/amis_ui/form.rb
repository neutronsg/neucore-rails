module Neucore
  module Helpers
    module AmisUi
      # Form helper module for generating Baidu Amis framework form components
      # Provides convenient Ruby methods to generate JSON schema for various Amis form inputs
      #
      # Each method returns a hash that can be converted to JSON for use in Amis forms
      # All methods accept an options hash to customize the form component behavior
      module Form
        # Generates a text input field schema for Amis forms
        #
        # @param options [Hash] Configuration options for the text input
        # @option options [String] :name Field name
        # @option options [String] :label Field label
        # @option options [String] :placeholder Placeholder text
        # @option options [Boolean] :trimContents Whether to trim whitespace (default: true)
        # @option options [Boolean] :clearValueOnHidden Clear value when field is hidden (default: true)
        # @return [Hash] Amis input-text schema
        def amis_form_text options = {}
          schema = options
          schema[:type] ||= 'input-text'
          schema[:trimContents] = true if schema[:trimContents].nil?
          schema[:clearValueOnHidden] = true if schema[:clearValueOnHidden].nil?
          schema[:labelAlign] = 'left'
          schema
        end

        # Generates a tag input field schema for Amis forms
        # Allows users to input multiple tags with batch adding support
        #
        # @param options [Hash] Configuration options for the tag input
        # @option options [String] :name Field name
        # @option options [String] :label Field label
        # @option options [Array] :options Available tag options
        # @option options [Boolean] :enableBatchAdd Enable batch adding of tags (default: true)
        # @option options [Boolean] :joinValues Join values with delimiter (default: false)
        # @option options [Boolean] :extractValue Extract value from option objects (default: true)
        # @return [Hash] Amis input-tag schema
        def amis_form_tag options = {}
          schema = options
          schema[:type] ||= 'input-tag'
          schema[:enableBatchAdd] = true if schema[:enableBatchAdd].nil?
          schema[:joinValues] = false if schema[:joinValues].nil?
          schema[:extractValue] = true if schema[:extractValue].nil?
          schema
        end

        # Generates a rich text editor field schema for Amis forms
        # Provides WYSIWYG editing capabilities with image upload support
        #
        # @param options [Hash] Configuration options for the rich text editor
        # @option options [String] :name Field name
        # @option options [String] :label Field label
        # @option options [String] :receiver Image upload endpoint (default: CMS images path)
        # @option options [Boolean] :trimContents Whether to trim whitespace (default: true)
        # @option options [Boolean] :clearValueOnHidden Clear value when field is hidden (default: true)
        # @return [Hash] Amis input-rich-text schema
        def amis_form_richtext options = {}
          schema = options
          schema[:type] ||= 'input-rich-text'
          schema[:trimContents] = true if schema[:trimContents].nil?
          schema[:clearValueOnHidden] = true if schema[:clearValueOnHidden].nil?
          schema[:labelAlign] = 'left'
          schema[:receiver] ||= "#{Neucore.configuration.cms_path}/images"
          schema
        end

        # Generates multiple text input fields for multilingual content (flattened naming)
        # Creates separate text fields for each configured locale with naming pattern: field_locale
        #
        # @param options [Hash] Configuration options for the multilingual text inputs
        # @option options [String] :name Base field name (will be suffixed with locale)
        # @option options [Class] :model ActiveRecord model class for generating localized labels
        # @return [Array<Hash>] Array of Amis input-text schemas, one for each locale
        def amis_form_flatten_ml options = {}
          schemas = []
          name = options.delete(:name)
          model = options.delete(:model)

          I18n.ml_locales.each do |locale|
            schemas << amis_form_text(options).merge(name: "#{name}_#{locale}", label: model.human_attribute_name("#{name}_#{locale}"), labelAlign: 'left')
          end

          schemas
        end

        # Generates multiple text input fields for multilingual content (nested naming)
        # Creates separate text fields for each configured locale with naming pattern: field_ml.locale
        #
        # @param options [Hash] Configuration options for the multilingual text inputs
        # @option options [String] :name Base field name (will be nested under _ml)
        # @option options [Class] :model ActiveRecord model class for generating localized labels
        # @return [Array<Hash>] Array of Amis input-text schemas, one for each locale
        def amis_form_ml options = {}
          schemas = []
          name = options.delete(:name)
          model = options.delete(:model)

          I18n.ml_locales.each do |locale|
            schemas << amis_form_text(options).merge(name: "#{name}_ml.#{locale}", label: model.human_attribute_name("#{name}_#{locale}"), labelAlign: 'left')
          end

          schemas
        end

        # Generates multiple rich text editor fields for multilingual content
        # Creates separate rich text editors for each configured locale with nested naming
        #
        # @param options [Hash] Configuration options for the multilingual rich text editors
        # @option options [String] :name Base field name (will be nested under _ml)
        # @option options [Class] :model ActiveRecord model class for generating localized labels
        # @return [Array<Hash>] Array of Amis input-rich-text schemas, one for each locale
        def amis_form_richml options = {}
          schemas = []
          name = options.delete(:name)
          model = options.delete(:model)

          I18n.ml_locales.each do |locale|
            schemas << amis_form_richtext(options).merge(name: "#{name}_ml.#{locale}", label: model.human_attribute_name("#{name}_#{locale}"), labelAlign: 'left')
          end

          schemas
        end

        # Generates a single image upload field schema for Amis forms
        # Provides image upload functionality with size restrictions
        #
        # @param options [Hash] Configuration options for the image upload
        # @option options [String] :name Field name (default: 'image')
        # @option options [String] :label Field label (default: localized 'Image')
        # @option options [String] :receiver Upload endpoint (default: CMS images path)
        # @option options [Integer] :maxSize Maximum file size in bytes (default: 10MB)
        # @option options [Boolean] :joinValues Join multiple values (default: false)
        # @return [Hash] Amis input-image schema
        def amis_form_image options = {}
          schema = options
          schema[:name] ||= 'image'
          schema[:label] ||= I18n.t('image', default: 'Image')
          schema[:labelAlign] = 'left'
          schema[:type] ||= 'input-image'
          schema[:receiver] ||= "#{Neucore.configuration.cms_path}/images"
          schema[:joinValues] = false if schema[:joinValues].nil?
          schema[:maxSize] ||= 10 * 1024 * 1024

          schema
        end

        # Generates a multiple images upload field schema for Amis forms
        # Provides multiple image upload functionality with drag-and-drop support
        #
        # @param options [Hash] Configuration options for the multiple images upload
        # @option options [String] :name Field name (default: 'images')
        # @option options [String] :label Field label (default: localized 'Images')
        # @option options [String] :receiver Upload endpoint (default: CMS images path)
        # @option options [Boolean] :multiple Enable multiple file selection (default: true)
        # @option options [String] :maxSize Maximum total size (default: "10m")
        # @option options [Integer] :maxLength Maximum number of files (default: 10MB)
        # @option options [Boolean] :draggable Enable drag-and-drop (default: true)
        # @option options [Boolean] :joinValues Join multiple values (default: false)
        # @return [Hash] Amis input-image schema for multiple images
        def amis_form_images options = {}
          schema = options
          schema[:name] ||= 'images'
          schema[:label] ||= I18n.t('images', default: 'Images')
          schema[:labelAlign] = 'left'
          schema[:type] ||= 'input-image'
          schema[:receiver] ||= "#{Neucore.configuration.cms_path}/images"
          schema[:joinValues] = false if schema[:joinValues].nil?
          schema[:multiple] = true if schema[:multiple].nil?
          schema[:maxSize] ||= "10m"
          schema[:maxLength] ||= 10 * 1024 * 1024
          schema[:draggable] = true if schema[:draggable].nil?

          schema
        end

        # Generates a video upload field schema for Amis forms
        # Provides video file upload functionality with MP4 format restriction
        #
        # @param options [Hash] Configuration options for the video upload
        # @option options [String] :name Field name (default: 'videos')
        # @option options [String] :label Field label (default: localized 'Videos')
        # @option options [String] :receiver Upload endpoint (default: CMS images path)
        # @option options [Boolean] :multiple Enable multiple file selection (default: true)
        # @option options [Integer] :maxLength Maximum number of files (default: 5)
        # @option options [Integer] :maxSize Maximum file size (default: 200MB)
        # @option options [Boolean] :useChunk Enable chunked upload (default: false)
        # @option options [Boolean] :joinValues Join multiple values (default: false)
        # @return [Hash] Amis input-file schema for video uploads
        def amis_form_videos options = {}
          schema = options
          schema[:name] ||= 'videos'
          schema[:label] ||= I18n.t('videos', default: 'Videos')
          schema[:labelAlign] = 'left'
          schema[:type] ||= 'input-file'
          schema[:receiver] ||= "#{Neucore.configuration.cms_path}/images"
          schema[:joinValues] = false if schema[:joinValues].nil?
          schema[:multiple] = true if schema[:multiple].nil?
          schema[:maxLength] ||= 5
          schema[:useChunk] = false if schema[:useChunk].nil?
          schema[:accept] = '.mp4'
          schema[:maxSize] ||= 200 * 1024 * 1024

          schema
        end

        # Generates a general file upload field schema for Amis forms
        # Provides file upload functionality with customizable file type restrictions
        #
        # @param options [Hash] Configuration options for the file upload
        # @option options [String] :name Field name (default: 'files')
        # @option options [String] :label Field label (default: localized 'Files')
        # @option options [String] :receiver Upload endpoint (default: CMS images path)
        # @option options [String] :accept Accepted file types (e.g., '.pdf,.doc,.docx')
        # @option options [Boolean] :multiple Enable multiple file selection (default: true)
        # @option options [Integer] :maxLength Maximum number of files (default: 5)
        # @option options [Integer] :maxSize Maximum file size (default: 200MB)
        # @option options [Boolean] :useChunk Enable chunked upload (default: false)
        # @option options [Boolean] :joinValues Join multiple values (default: false)
        # @return [Hash] Amis input-file schema for general file uploads
        def amis_form_files options = {}
          schema = options
          schema[:name] ||= 'files'
          schema[:label] ||= I18n.t('files', default: 'Files')
          schema[:labelAlign] = 'left'
          schema[:type] ||= 'input-file'
          schema[:receiver] ||= "#{Neucore.configuration.cms_path}/images"
          schema[:joinValues] = false if schema[:joinValues].nil?
          schema[:multiple] = true if schema[:multiple].nil?
          schema[:maxLength] ||= 5
          schema[:useChunk] = false if schema[:useChunk].nil?
          schema[:accept] = options[:accept]
          schema[:maxSize] ||= 200 * 1024 * 1024

          schema
        end

        # Generates a switch (toggle) field schema for Amis forms
        # Provides a boolean toggle control for on/off or true/false values
        #
        # @param options [Hash] Configuration options for the switch
        # @option options [String] :name Field name
        # @option options [String] :label Field label
        # @option options [Boolean] :clearValueOnHidden Clear value when field is hidden (default: true)
        # @return [Hash] Amis switch schema
        def amis_form_switch options = {}
          schema = options
          schema[:type] ||= 'switch'
          schema[:labelAlign] = 'left'
          schema[:clearValueOnHidden] = true if schema[:clearValueOnHidden].nil?

          schema
        end

        # Generates a single checkbox field schema for Amis forms
        # Provides a boolean checkbox control for single true/false values
        #
        # @param options [Hash] Configuration options for the checkbox
        # @option options [String] :name Field name
        # @option options [String] :label Field label
        # @option options [Boolean] :clearValueOnHidden Clear value when field is hidden (default: true)
        # @return [Hash] Amis checkbox schema
        def amis_form_checkbox options = {}
          schema = options
          schema[:type] ||= 'checkbox'
          schema[:labelAlign] = 'left'
          schema[:clearValueOnHidden] = true if schema[:clearValueOnHidden].nil?

          schema
        end

        # Generates a multiple checkboxes field schema for Amis forms
        # Provides multiple checkbox options for selecting multiple values from a list
        #
        # @param options [Hash] Configuration options for the checkboxes
        # @option options [String] :name Field name
        # @option options [String] :label Field label
        # @option options [Array] :options Available checkbox options
        # @option options [Boolean] :joinValues Join values with delimiter (default: false)
        # @option options [Boolean] :extractValue Extract value from option objects (default: true)
        # @option options [Boolean] :checkAll Show "check all" option (default: true)
        # @option options [Boolean] :clearValueOnHidden Clear value when field is hidden (default: true)
        # @return [Hash] Amis checkboxes schema
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

        # Generates a select dropdown field schema for Amis forms
        # Provides a dropdown selection control with search and clear functionality
        #
        # @param options [Hash] Configuration options for the select dropdown
        # @option options [String] :name Field name
        # @option options [String] :label Field label
        # @option options [Array] :options Available select options
        # @option options [Boolean] :joinValues Join values with delimiter (default: false)
        # @option options [Boolean] :extractValue Extract value from option objects (default: true)
        # @option options [Boolean] :clearValueOnHidden Clear value when field is hidden (default: true)
        # @option options [Boolean] :clearable Show clear button (default: true)
        # @option options [Boolean] :searchable Enable search functionality (default: true)
        # @return [Hash] Amis select schema
        def amis_form_select options = {}
          schema = options
          schema[:type] ||= 'select'
          schema[:labelAlign] = 'left'
          schema[:joinValues] = false if schema[:joinValues].nil?
          schema[:extractValue] = true if schema[:extractValue].nil?
          schema[:clearValueOnHidden] = true if schema[:clearValueOnHidden].nil?
          schema[:clearable] = true if schema[:clearable].nil?
          if schema[:searchable].nil?
            schema[:searchable] = schema[:options].nil? || (schema[:options].present? && schema[:options].length > 5)
          end

          schema
        end

        # Generates a tree-select field schema for Amis forms
        # Provides hierarchical selection with tree structure for nested options
        #
        # @param options [Hash] Configuration options for the tree select
        # @option options [String] :name Field name
        # @option options [String] :label Field label
        # @option options [Array] :options Tree-structured options with children
        # @option options [Boolean] :joinValues Join values with delimiter (default: false)
        # @option options [Boolean] :extractValue Extract value from option objects (default: true)
        # @option options [Boolean] :clearValueOnHidden Clear value when field is hidden (default: true)
        # @option options [Boolean] :clearable Show clear button (default: true)
        # @return [Hash] Amis tree-select schema
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

        # Generates a radio buttons field schema for Amis forms
        # Provides single selection from multiple options using radio buttons
        #
        # @param options [Hash] Configuration options for the radio buttons
        # @option options [String] :name Field name
        # @option options [String] :label Field label
        # @option options [Array] :options Available radio button options
        # @option options [Boolean] :clearValueOnHidden Clear value when field is hidden (default: true)
        # @return [Hash] Amis radios schema
        def amis_form_radios options = {}
          schema = options
          schema[:type] ||= 'radios'
          schema[:labelAlign] = 'left'
          schema[:clearValueOnHidden] = true if schema[:clearValueOnHidden].nil?

          schema
        end

        # Generates an input table field schema for Amis forms
        # Provides an editable table interface for managing structured data
        #
        # @param options [Hash] Configuration options for the input table
        # @option options [String] :name Field name
        # @option options [String] :label Field label
        # @option options [Array] :columns Table column definitions
        # @option options [Boolean] :needConfirm Require confirmation for changes (default: false)
        # @option options [Boolean] :removable Allow row removal (default: true)
        # @option options [Boolean] :addable Allow row addition (default: true)
        # @return [Hash] Amis input-table schema
        def amis_form_table options = {}
          schema = options
          schema[:type] = 'input-table'
          schema[:needConfirm] = false if schema[:needConfirm].nil?
          schema[:removable] = true if schema[:removable].nil?
          schema[:addable] = true if schema[:addable].nil?

          schema
        end

        # Helper method to create Amis combo component for nested forms
        def amis_form_combo(options = {})
          schema = options
          schema = schema.merge({
            type: 'combo',
            name: options[:name],
            label: options[:label],
            description: options[:description],
            multiple: options[:multiple] != false, # default to true
            multiLine: options[:multiLine] != false, # default to true
            addable: options[:addable] != false, # default to true
            removable: options[:removable] != false, # default to true
            draggable: options[:draggable] != false, # default to true
            minLength: options[:minLength] || 0,
            maxLength: options[:maxLength], # optional max length
            items: items,
            addButtonText: options[:addButtonText] || I18n.t('actions.add', default: 'Add'),
            scaffold: options[:scaffold] || {},
            tabsMode: options[:tabsMode], # for tabbed layout within combo items
            tabsLabelTpl: options[:tabsLabelTpl], # template for tab labels
            mode: options[:mode] # 'table', 'normal', 'tabs', etc.
          })

          # Remove nil values to keep the schema clean
          schema.compact
        end
        # Generates standard form panel actions (Cancel, Reset, Submit buttons)
        # Provides a consistent set of action buttons for form panels
        #
        # @return [Hash] Amis flex layout with standard form action buttons
        def amis_panel_actions
          schema = {
            type: 'flex',
            justify: 'flex-end',
            items: [
              {
                type: 'button', label: I18n.t('cancel'), size: 'sm',
                onEvent: {click: {actions: [{actionType: 'goBack'}]}},
                style: {'margin-right': 8}
              },
              {
                type: 'reset', label: I18n.t('reset'), size: 'sm'
              },
              {
                type: 'submit', label: I18n.t('submit'), size: 'sm', level: 'primary', style: {'margin-left': 8}
              }
            ]
          }
        end
      end
    end
  end
end
