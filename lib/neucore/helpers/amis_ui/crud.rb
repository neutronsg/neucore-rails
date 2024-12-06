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
            tabsMode: 'line',
            tabs: tabs,
            className: 'crudTabs',
            visibleOn: "${scopes}",
            activeKey: "${INT(scope)}",
            onEvent: {
              change: {
                actions: [
                  {
                    componentId: 'crud',
                    actionType: 'reload',
                    data: {
                      scope: "${scope_keys[event.data.value - 1]}"
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
          popOver = options.delete(:popOver)
          schema = options
          if options[:maxLength]
            schema[:type] = 'tpl'
            schema[:className] = 'line-clamp-1'
            schema[:tpl] = "${ #{options[:name]}|truncate:#{options[:maxLength]} }"
          end

          if popOver
            schema[:popOver] = {
              trigger: 'hover',
              position: 'left-top',
              showIcon: false,
              visibleOn: "${ #{options[:name]}.length > #{options[:maxLength]} }",
              body: {
                type: 'tpl',
                tpl: "${ #{options[:name]} }"
              }
            }
          end

          schema
        end

        def amis_datetime_column options = {}
          name = options.delete(:name)
          schema = options
          schema[:tpl] = "${ DATETOSTR(#{name}) }"

          schema
        end

        def amis_html_column options = {}
          name = options.delete(:name)
          schema = options
          schema[:type] = 'html'
          schema[:html] = "${raw(#{name})}"

          schema
        end

        def amis_avatar_column options = {}
          schema = options.slice(:name, :label)
          schema[:type] = 'avatar'
          schema[:src] = "${#{options[:name]}}"
          
          schema
        end

        def amis_image_column options = {}
          schema = options.slice(:name, :label)
          schema[:type] = 'image'
          schema[:placeholder] = '-'

          schema
        end

        def amis_video_column options = {}
          schema = options.slice(:name, :label)
          schema[:type] = 'video'
          schema[:body] = {
            src: "${#{options[:name]}}",
          }

          schema
        end

        def amis_images_column options = {}
          schema = options.slice(:name, :label)
          schema[:type] = 'images'
          schema[:defaultImage] = ''

          schema
        end

        def amis_clickable_column options = {}
          schema = options.slice(:name, :label, :searchable)
          schema[:type] = 'button'
          schema[:body] = {
            type: 'button',
            level: 'link',
            tooltip: options[:tooltip] || options[:label],
            actionType: 'link',
            label: "${#{options[:name]}.label}",
            link: "/${#{options[:name]}.resource}/${#{options[:name]}.id}"
          }

          schema
        end

        def amis_clickables_column options = {}
          schema = {
            name: options[:name],
            type: 'each',
            label: options[:label],
            placeholder: options[:placeholder] || '-',
            items: {
              type: 'button',
              actionType: 'link',
              level: 'link',
              label: "${item.label}",
              link: "/${item.resource}/${item.id}"
            }
          }

          schema
        end

        def amis_switch_column options = {}
          resource = options.delete(:resource) || @resource
          action = options.delete(:action) || options[:name] || 'switch'
          method = options.delete(:method) || 'post'

          schema = options
          schema[:type] = 'switch'
          schema[:mode] = 'horizontal'
          schema[:onEvent] = {
            change: {
              actions: [
                {
                  actionType: 'ajax',
                  api: "#{method}:cms/#{resource}/${id}/#{action}",
                }
              ]
            }
          }

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
          resource = options.delete(:resource) || @resource
          api = {
            method: options.delete(:method) || 'post',
            url: options.delete(:url),
            data: {ids: "${split(ids)}"}
          }
          schema = options
          schema[:type] ||= 'button'
          schema[:actionType] ||= 'ajax'
          schema[:api] = api
          schema[:redirect] ||= "/#{resource}"

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

