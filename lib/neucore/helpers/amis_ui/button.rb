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

        def amis_download_link_button options = {}
          resource = options[:resource] || @resource
          action = options[:action] || 'download'
          method = options[:method] || 'get'
          api = options.delete(:api) || "#{method}:#{Neucore.configuration.cms_path}/#{resource}/${id}/#{action}"
          schema = {
            type: options[:type] || 'button',
            label: options[:label] || I18n.t(action, default: action.titleize),
            level: options[:level] || 'primary',
            visibleOn: "${ARRAYINCLUDES(permissions, '#{action}')}",
            onEvent: {
              click: {
                actions: [
                  {
                    actionType: 'ajax',
                    args: {
                      api: api
                    }
                  },
                  {
                    actionType: 'url',
                    data: {
                      url: "${responseResult.url}"
                    },
                    args: {
                      url: "${url}",
                      blank: false
                    }
                  }
                ]
              }
            }
          }

          schema
        end

        def amis_selection_dialog options = {}
          crud = amis_crud_base
          crud[:api] = options[:api]
          # crud[:id] = "ticket_products_dialog"
          crud[:selectable] = true
          crud[:multiple] = true
          crud[:headerToolbar] = []
          crud[:columns] = options[:columns]

          crud[:onEvent] = {
            selectedChange: {
              actions: [
                {
                  actionType: "setValue",
                  componentId: "selection_dialog_form",
                  args: {
                    value: {
                      ids: "${ARRAYMAP(event.data.selectedItems, item => item.id)}"
                    }
                  }
                }
              ]
            }
          }

          schema = {
            type: "button",
            label: options[:label] || 'Add Item',
            level: options[:level] || 'primary',
            onEvent: {
              click: {
                actions: [
                  {
                    actionType: "dialog",
                    dialog: {
                      title: options[:label] || 'Add Item',
                      size: options[:size] || "xl",
                      body: [
                        {
                          type: "form",
                          id: "selection_dialog_form",
                          preventEnterSubmit: true,
                          data: {ids: []},
                          onEvent: {
                            submit: {
                              actions: [
                                {
                                  actionType: "setValue",
                                  componentId: "form",
                                  args: {
                                    value: {
                                      selection_ids:
                                        "${CONCAT(ids, selection_ids)}"
                                    }
                                  }
                                },
                                {
                                  actionType: "reload",
                                  componentId: "selection_table"
                                }
                              ]
                            }
                          },
                          body: crud
                        }
                      ]
                    }
                  },
                ]
              }
            }
          }
        end
      end
    end
  end
end


