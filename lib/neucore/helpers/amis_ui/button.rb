module Neucore
  module Helpers
    module AmisUi
      module Button
        def amis_create_button resource = nil
          resource ||= @resource
          schema = {
            type: 'button',
            label: I18n.t('actions.create'),
            icon: 'fa fa-plus pull-left',
            primary: true,
            actionType: 'link',
            link: "/#{resource}/create"
          }
          schema
        end

        def amis_view_button resource = nil
          resource ||= @resource
          schema = {
            type: 'button',
            level: 'link',
            label: I18n.t('view'),
            tooltip: I18n.t('view'),
            actionType: 'link',
            link: "/#{resource}/${id}"
          }
          schema
        end

        def amis_edit_button resource = nil
          resource ||= @resource
          schema = {
            type: 'button',
            level: 'link',
            label: I18n.t('edit'),
            tooltip: I18n.t('edit'),
            actionType: 'link',
            link: "/#{resource}/${id}/edit"
          }
          schema
        end

        def amis_clickable options = {}
          schema = {
            type: 'button',
            level: 'link',
            tooltip: options[:tooltip] || options[:label],
            actionType: 'link',
            label: options[:label],
            link: "/${#{options[:name]}.resource}/${#{options[:name]}.id}"
          }
          schema
        end

        def amis_clickables options = {}
          schema = {
            name: options[:name],
            type: 'each',
            label: options[:label],
            placeholder: options[:placeholder] || '-',
            items: {
              type: 'button',
              actionType: 'link',
              level: 'link',
              label: "${item.name}",
              link: "/${item.resource}/${item.id}"
            }
          }
          schema
        end
      end
    end
  end
end


