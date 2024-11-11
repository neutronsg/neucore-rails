module Neucore
  module Helpers
    module FormilyUi
      def formily_string(options = {})
        options[:type] ||= 'string'
        options[:title] ||= I18n.t('title')
        options[:'x-decorator'] = options[:'x-decorator'] || options[:decorator] || 'FormItem'
        options[:'x-index'] ||= options.delete(:index) || 1
        %i[required visible disabled].each do |attribute|
          value = options[:"x-#{attribute}"] || options[attribute]
          options[:"x-#{attribute}"] = value unless value.nil?
        end

        options[:'x-component'] = options[:'x-component'] || options[:component] || 'Input'
        options[:'x-validator'] = options[:'x-validator'] || options[:validator] || []
        options
      end

      def formily_textarea(options = {})
        options = formily_string(options)
        options[:'x-component'] = 'Input.TextArea'
        options
      end

      def formily_richtext(options = {})
        options = formily_string(options)
        options[:'x-component'] = 'RichText'
        options
      end

      def formily_color(options = {})
        options[:type] ||= 'string'
        options[:title] ||= I18n.t('title')
        options[:'x-decorator'] = options[:'x-decorator'] || options[:decorator] || 'FormItem'
        options[:'x-index'] ||= options.delete(:index) || 1
        %i[required visible disabled].each do |attribute|
          value = options[:"x-#{attribute}"] || options[attribute]
          options[:"x-#{attribute}"] = value unless value.nil?
        end

        options[:'x-component'] = options[:'x-component'] || options[:component] || 'ColorPicker'
        options[:'x-validator'] = options[:'x-validator'] || options[:validator] || []
        options
      end

      def formily_enum(options = {})
        options[:type] ||= 'string'
        options[:title] ||= I18n.t('title')
        options[:'x-decorator'] = options[:'x-decorator'] || options[:decorator] || 'FormItem'
        options[:'x-index'] ||= options.delete(:index) || 1
        %i[required visible disabled].each do |attribute|
          value = options[:"x-#{attribute}"] || options[attribute]
          options[:"x-#{attribute}"] = value unless value.nil?
        end

        options[:'x-component'] = options[:'x-component'] || options[:component] || 'Select'
        options[:'x-component-props'] = {
          clearable: true,
          placeholder: options[:placeholder] || options[:title] || ''
        }
        options
      end

      def formily_switch(options = {})
        options[:type] = 'boolean'
        options[:title] ||= I18n.t('title')
        options[:'x-decorator'] = options[:'x-decorator'] || options[:decorator] || 'FormItem'
        options[:'x-index'] ||= options.delete(:index) || 1
        %i[required visible disabled].each do |attribute|
          value = options[:"x-#{attribute}"] || options[attribute]
          options[:"x-#{attribute}"] = value unless value.nil?
        end

        options[:'x-component'] = options[:'x-component'] || options[:component] || 'Switch'
        options[:'x-validator'] = options[:'x-validator'] || options[:validator] || []
        value = options.delete(:value)
        options[:'x-value'] = value.nil? ? true : value
        options
      end

      def formily_number(options = {})
        options[:type] = 'number'
        options[:title] ||= I18n.t('title')
        options[:'x-decorator'] = options[:'x-decorator'] || options[:decorator] || 'FormItem'
        options[:'x-index'] ||= options.delete(:index) || 1
        %i[required visible disabled].each do |attribute|
          value = options[:"x-#{attribute}"] || options[attribute]
          options[:"x-#{attribute}"] = value unless value.nil?
        end

        options[:'x-component'] = options[:'x-component'] || options[:component] || 'NumberPicker'
        options[:'x-validator'] = options[:'x-validator'] || options[:validator] || 'number'
        options
      end

      def formily_file(options = {})
        options[:type] ||= 'string'
        options[:title] ||= I18n.t('title')
        options[:'x-decorator'] = options[:'x-decorator'] || options[:decorator] || 'FormItem'
        options[:'x-component'] = options[:'x-component'] || options[:component] || 'File'
        options[:'x-validator'] = options[:'x-validator'] || options[:validator] || []
        options[:'x-component-props'] = {
          accept: options[:accept].nil? ?  '.csv': options.delete(:accept),
          description: options[:description].nil? ? 'Only support .csv file' : options.delete(:description)
        }
        options
      end

      def formily_datetime_range(options = {})
        options[:type] = 'string'
        options[:title] ||= I18n.t('title')
        options[:'x-decorator'] = options[:'x-decorator'] || options[:decorator] || 'FormItem'
        options[:'x-index'] ||= options.delete(:index) || 1
        %i[required visible disabled].each do |attribute|
          value = options[:"x-#{attribute}"] || options[attribute]
          options[:"x-#{attribute}"] = value unless value.nil?
        end

        options[:'x-component'] = options[:'x-component'] || options[:component] || 'DatePicker'
        options[:'x-validator'] = options[:'x-validator'] || options[:validator] || []
        showTime = options.delete(:showTime)
        showTime = true if showTime.nil?
        options[:'x-component-props'] = {
          clearable: true,
          picker: 'date',
          showTime: showTime,
          valueFormat: options[:format] || 'yyyy-MM-dd HH:mm',
          startPlaceholder: 'Start Date',
          endPlaceholder: 'End Date',
          placeholder: 'Date Range',
          type: 'datetimerange'
        }
        options
      end

      def formily_datetime(options = {})
        options[:type] = 'string'
        options[:title] ||= I18n.t('title')
        options[:'x-decorator'] = options[:'x-decorator'] || options[:decorator] || 'FormItem'
        options[:'x-index'] ||= options.delete(:index) || 1
        %i[required visible disabled].each do |attribute|
          value = options[:"x-#{attribute}"] || options[attribute]
          options[:"x-#{attribute}"] = value unless value.nil?
        end

        options[:'x-component'] = options[:'x-component'] || options[:component] || 'DatePicker'
        options[:'x-validator'] = options[:'x-validator'] || options[:validator] || []
        showTime = options.delete(:showTime)
        showTime = true if showTime.nil?
        options[:'x-component-props'] = {
          picker: 'date',
          showTime: showTime,
          format: options[:format]
        }
        options
      end

      def formily_images(options = {})
        options[:type] = 'Array<object>'
        options[:title] ||= I18n.t('title')
        options[:'x-decorator'] = options[:'x-decorator'] || options[:decorator] || 'FormItem'
        options[:'x-index'] ||= options.delete(:index) || 1
        %i[required visible disabled].each do |attribute|
          value = options[:"x-#{attribute}"] || options[attribute]
          options[:"x-#{attribute}"] = value unless value.nil?
        end

        options[:'x-component'] = options[:'x-component'] || options[:component] || 'UploadImage'
        options[:'x-validator'] = options[:'x-validator'] || options[:validator] || []
        options[:'x-component-props'] = {
          action: '/cms/images',
          limit: options[:limit] || 10
        }
        options
      end

      # 需要在action_config设置header： Content-Type, 'multipart/form-data'
      def formily_image(options = {})
        options[:type] ||= 'string'
        options[:title] ||= I18n.t('title')
        options[:'x-decorator'] = options[:'x-decorator'] || options[:decorator] || 'FormItem'
        options[:'x-component'] = options[:'x-component'] || options[:component] || 'FImage'
        options[:'x-validator'] = options[:'x-validator'] || options[:validator] || []
        options[:'x-index'] ||= options.delete(:index) || 1
        options
      end

      def formily_video(options = {})
        options[:type] = 'string'
        options[:title] ||= I18n.t('title')
        options[:'x-decorator'] = options[:'x-decorator'] || options[:decorator] || 'FormItem'
        options[:'x-index'] ||= options.delete(:index) || 1

        options[:'x-component'] = options[:'x-component'] || options[:component] || 'FVideo'
        options[:'x-validator'] = options[:'x-validator'] || options[:validator] || []
        options
      end

      def formily_fcheckbox(options = {})
        options[:type] ||= 'array'
        options[:title] ||= I18n.t('title')
        options[:'x-decorator'] = options[:'x-decorator'] || options[:decorator] || 'FormItem'
        options[:'x-index'] ||= options.delete(:index) || 1
        options[:'x-component'] = options[:'x-component'] || options[:component] || 'FCheckbox'
        options[:'x-validator'] = options[:'x-validator'] || options[:validator] || []
        options
      end

      def formily_fselect(options = {})
        options[:type] ||= 'array'
        options[:title] ||= I18n.t('title')
        options[:'x-decorator'] = options[:'x-decorator'] || options[:decorator] || 'FormItem'
        options[:'x-index'] ||= options.delete(:index) || 1
        %i[required visible disabled value].each do |attribute|
          value = options[:"x-#{attribute}"] || options[attribute]
          options[:"x-#{attribute}"] = value unless value.nil?
        end

        options[:'x-component'] = options[:'x-component'] || options[:component] || 'FSelect'
        options[:'x-validator'] = options[:'x-validator'] || options[:validator] || []
        options[:'x-component-props'] = {
          clearable: options[:clearable].nil? ? false : options.delete(:clearable),
          multiple: options[:multiple].nil? ? true : options.delete(:multiple),
          remote: options[:remote].nil? ? true : options.delete(:remote),
          url: options.delete(:url) || 'cms/forms/simple_list',
          response_data_path: options.delete(:response_data_path) || 'data.objects',
          params: {resource: options.delete(:resource)}.merge(options.delete(:q) || {}),
        }
        options
      end

      def formily_fselect_lazy(options = {})
        options = formily_fselect(options)
        options[:'x-component-props'][:lazy] = true
        options[:'x-component-props'][:queryKey] = options[:queryKey] || 'q'
        options[:'x-component-props'][:filterable] = true
        options[:'x-component-props'][:params][:per_page] = options.delete(:per_page) || 100
        options[:'x-component-props'][:options] = options[:options] if options[:options].present?
        options
      end

      def formily_index options = {}
        options[:type] = 'void'
        options[:'x-component'] = 'ArrayCards.Index'
        options[:'x-index'] ||= options.delete(:index) || 1
        options
      end

      def formily_addition
        {
          addition: {
            type: 'void',
            title: I18n.t('add'),
            'x-component': 'ArrayItems.Addition',
            'x-component-props': {},
            'x-index': 0
          }
        }
      end

      def formily_remove options = {}
        options[:type] = 'void'
        options[:'x-component'] = options[:'x-component'] || options[:component] || 'ArrayItems.Remove'
        options[:'x-index'] ||= options.delete(:index) || 1
        options
      end

      def formily_sort options = {}
        options[:type] = 'void'
        options[:'x-decorator'] = 'FormItem'
        options[:'x-component'] = 'ArrayItems.SortHandle'
        options[:'x-index'] ||= options.delete(:index) || 1
        options
      end

      def formily_dependencies_for dep, options = {}
        {
          dependencies: [".#{dep}"],
          fulfill: {
            state: {
              visible: options[:condition] || '{{$deps[0]}}'
            }
          }
        }
      end
      
      def formily_undependencies_for dep, options = {}
        {
          dependencies: [".#{dep}"],
          fulfill: {
            state: {
              hidden: options[:condition] || '{{$deps[0]}}'
            }
          }
        }
      end
    end
  end
end