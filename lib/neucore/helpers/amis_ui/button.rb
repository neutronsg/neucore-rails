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
          schema[:level] ||= 'primary'
          schema[:label] ||= I18n.t('view')
          schema[:actionType] ||= 'link'
          schema[:link] ||= "/#{resource}/${id}"
          schema[:visibleOn] = options[:visibleOn] || "${ARRAYINCLUDES(permissions, 'read')}"

          schema
        end

        def amis_edit_button options = {}
          resource = options.delete(:resource) || @resource
          schema = options
          schema[:type] ||= 'button'
          schema[:level] ||= 'primary'
          schema[:label] ||= I18n.t('edit')
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
          schema[:actionType] ||= 'ajax'
          schema[:confirmText] = I18n.t('delete_confirmation')
          schema[:api] ||= "delete:#{Neucore.configuration.cms_path}/#{resource}/${id}"
          schema[:visibleOn] = "${ARRAYINCLUDES(permissions, 'destroy')}"
          if @type == 'list'
            schema[:reload] = 'page_crud,crud'
          else
            schema[:redirect] ||= "/#{resource}"
          end
          schema
        end

        def amis_restore_button options = {}
          resource = options.delete(:resource) || @resource
          schema = options
          schema[:type] ||= 'button'
          schema[:level] ||= 'primary'
          schema[:label] ||= I18n.t('restore')
          schema[:actionType] ||= 'ajax'
          schema[:confirmText] = I18n.t('restore_confirmation')
          schema[:api] ||= "post:#{Neucore.configuration.cms_path}/#{resource}/${id}/restore"
          schema[:visibleOn] = "${ARRAYINCLUDES(permissions, 'restore')}"
          if @type == 'list'
            schema[:reload] = 'page_crud,crud'
          else
            schema[:redirect] = "/#{resource}"
          end

          schema
        end

        def amis_member_button options = {}
          resource = options.delete(:resource) || @resource
          action = options.delete(:action)
          method = options.delete(:method) || 'post'
          schema = options

          schema[:type] ||= 'button'
          schema[:level] ||= 'primary'
          schema[:label] ||= I18n.t(action, default: action.titleize)
          schema[:actionType] ||= 'ajax'
          schema[:api] ||= "#{method}:#{Neucore.configuration.cms_path}/#{resource}/${id}/#{action}"
          schema[:visibleOn] = "${ARRAYINCLUDES(permissions, '#{action}')}"
          if @type == 'list' && schema[:redirect].nil?
            schema[:reload] = 'page_crud,crud'
          else
            schema[:redirect] ||= "/#{resource}"
          end

          schema
        end
      end
    end
  end
end


