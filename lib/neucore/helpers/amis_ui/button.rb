module Neucore
  module Helpers
    module AmisUi
      module Button
        def amis_create_button options = {}
          resource = options.delete(:resource) || @resource
          schema = options
          schema[:type] ||= 'button'
          schema[:level] ||= 'primary'
          schema[:icon] ||= 'fa fa-plus pull-left'
          schema[:label] ||= I18n.t('create')
          schema[:actionType] ||= 'link'
          schema[:link] ||= "/#{resource}/create"
          schema[:visibleOn] = "${ARRAYINCLUDES(permissions, 'create')}"

          schema
        end

        def amis_view_button options = {}
          resource = options.delete(:resource) || @resource
          schema = options
          schema[:type] ||= 'button'
          schema[:level] ||= 'link'
          schema[:label] ||= I18n.t('view')
          schema[:tooltip] ||= I18n.t('view')
          schema[:actionType] ||= 'link'
          schema[:link] ||= "/#{resource}/${id}"
          schema[:visibleOn] = "${ARRAYINCLUDES(permissions, 'read')}"

          schema
        end

        def amis_edit_button options = {}
          resource = options.delete(:resource) || @resource
          schema = options
          schema[:type] ||= 'button'
          schema[:level] ||= 'link'
          schema[:label] ||= I18n.t('edit')
          schema[:tooltip] ||= I18n.t('edit')
          schema[:actionType] ||= 'link'
          schema[:link] ||= "/#{resource}/${id}/edit"
          schema[:visibleOn] = "${ARRAYINCLUDES(permissions, 'update')}"

          schema
        end

        def amis_delete_button options = {}
          resource = options.delete(:resource) || @resource
          schema = options
          schema[:type] ||= 'button'
          schema[:level] ||= 'danger'
          schema[:label] ||= I18n.t('delete')
          schema[:tooltip] ||= I18n.t('delete')
          schema[:actionType] ||= 'ajax'
          schema[:api] ||= "delete:cms/#{resource}/${id}"
          schema[:visibleOn] = "${ARRAYINCLUDES(permissions, 'destroy')}"

          schema
        end
      end
    end
  end
end


