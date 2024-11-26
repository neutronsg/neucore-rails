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
      end
    end
  end
end


