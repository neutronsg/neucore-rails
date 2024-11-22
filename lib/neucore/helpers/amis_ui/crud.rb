module Neucore
  module Helpers
    module AmisUi
      module Crud
        def amis_crud_tabs scopes
          tabs = []
          scopes.each do |scope|
            tabs << {
              title: {
                type: 'tpl',
                tpl: "${scopes.#{scope}.title}(${scopes.#{scope}.count})"
              }
            }
          end

          schema = {
            type: 'tabs',
            tabsMode: 'radio',
            tabs: tabs,
            className: 'crudTabs',
            visibleOn: "${scopes}",
            onEvent: {
              change: {
                actions: [
                  {
                    componentId: 'crud',
                    actionType: 'reload',
                    data: {
                      scope: "${scopes[event.data.value - 1]}"
                    }
                  }
                ]
              }
            }
          }
          schema
        end
        
        def amis_id_column options = {}
          schema = {
            name: 'id',
            label: 'ID',
            fixed: 'left'
          }.merge(options)

          schema
        end

        def amis_string_column options = {}
          schema = options
          schema
        end

        def amis_datetime_column options = {}
          schema = {
            label: options[:label],
            type: 'tpl',
            tpl: "${ DATETOSTR(#{options[:name]}) }"
          }

          schema
        end

        def amis_html_column options = {}
          schema = {
            label: options[:label],
            type: 'tpl',
            tpl: "${raw(#{options[:name]})}"
          }

          schema
        end

        def amis_image_column options = {}
          schema = options.slice(:name, :label)
          schema[:type] = 'image'
          schema[:placeholder] = '-'

          schema
        end

        def amis_images_column options = {}
          schema = options.slice(:name, :label)
          schema[:type] = 'images'
          schema[:defaultImage] = ''

          schema
        end

        def amis_tag_column options = {}
          schema = {
            name: options[:name],
            type: 'tag',
            label: options[:label] || 'Tag',
            color: options[:color] || 'processing',
            placeholder: options[:placeholder] || '-'
          }
          
          schema
        end

        def amis_tags_column options = {}
          schema = {
            name: options[:name] || 'tags',
            type: 'each',
            label: options[:label] || 'Tags',
            placeholder: options[:placeholder] || '-',
            items: {
              type: 'tag',
              color: "${item.color || 'processing'}",
              label: "${item.name || item.tag || item}"
            }
          }
          schema
        end

        def amis_bulk_action options = {}
          api = {
            method: options.delete(:method) || 'post',
            url: options.delete(:url),
            data: {ids: "${split(ids)}"}
          }
          schema = options
          schema[:type] ||= 'button'
          schema[:actionType] ||= 'ajax'
          schema[:api] = api
          
          schema
        end

        def amis_export_csv options = {}
          schema = options
          schema[:type] = 'export-csv'
          schema[:label] ||= I18n.t('actions.export_csv')
          schema[:align] ||= 'right'
          schema[:filename] ||= "#{Time.now.to_i}"

          schema
        end

        def amis_export_excel options = {}
          schema = options
          schema[:type] = 'export-excel'
          schema[:label] ||= I18n.t('actions.export_excel')
          schema[:align] ||= 'right'
          schema[:filename] ||= "#{Time.now.to_i}"

          schema
        end

        def amis_export_excel_template options = {}
          schema = options
          schema[:type] = 'export-excel-template'
          schema[:label] ||= I18n.t('actions.export_excel_template')
          schema[:align] ||= 'right'
          schema[:filename] ||= "#{Time.now.to_i}"

          schema
        end
      end
    end
  end
end

