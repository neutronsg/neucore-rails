module Neucore
  module Helpers
    module AmisUi
      module Crud
        def amis_crud_scopes scopes
          scopes = scopes.collect{|scope| {label: I18n.t(scope, default: scope.titleize), value: scope}}
          schema = {
            type: 'button-group-select',
            name: 'type',
            options: scopes,
            onEvent: {
              change: {
                actions: [
                  {
                    componentId: 'crud',
                    actionType: 'reload',
                    data: {
                      scope: "${event.data.value}"
                    }
                  }
                ]
              }
            }
          }
          schema
        end

        def amis_crud_tabs tabs
          tabs = tabs.collect{|tab| {title: I18n.t(tab, default: tab.titleize)}}
          schema = {
            type: 'tabs',
            mode: 'line',
            tabs: tabs,
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
      end
    end
  end
end
