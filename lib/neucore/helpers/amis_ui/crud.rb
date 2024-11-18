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

        def amis_string_column model = nil, field = nil, options = {}
          schema = {
            name: field,
            label: model.human_attribute_name(field)
          }.merge(options)
          
          schema
        end

        def amis_boolean_column name = '', label = ''
          schema = {
            name: name,
            type: 'tag',
            label: label,
            color: 'processing'
          }
          schema
        end

        def amis_tag_column options = {}
          schema = {
            type: 'tag',
            label: options[:label] || 'Tag',
            color: options[:color] || 'processing',
            placeholder: '-'
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
