json.type 'wrapper'
json.style do
  json.padding '0'
end

json.body do
  json.child! do
    json.type 'breadcrumb'
    json.items do
      json.child! do
        json.label I18n.t('permissions.settings')
      end

      json.child! do
        json.label I18n.t('permissions.admin_user')
      end
    end
    json.style do
      json.set! 'margin-bottom', '12px'
    end
  end

  json.child! do
    json.type 'page'
    json.toolbar do
      json.type 'container'
      json.style do
        json.padding '12px 12px 0 12px'
      end

      json.body do
        json.type 'button'
        json.label I18n.t('actions.create')
        json.icon 'fa fa-plus pull-left'
        json.primary true
        json.actionType 'link'
        json.link '/admin_users/create'
      end
    end
    json.body do
      json.child! do
        json.type 'crud'
        json.draggable true
        json.api 'amis/admin_users'
        json.perPage 50
        json.keepItemSelectionOnPageChange true
        json.maxKeepItemSelectionLength 11
        json.autoFillHeight false
        json.labelTpl "${id} ${name}"
        json.autoGenerateFilter true
        json.filterTogglable true
        json.headerToolbar do
          json.child! do
            json.type 'columns-toggler'
            json.align 'right'
          end

          json.child! do
            json.type 'drag-toggler'
            json.align 'right'
          end

          json.child! do
            json.type 'pagination'
            json.align 'right'
          end
        end

        json.footerToolbar ['statistics', 'switch-per-page', 'pagination']

        json.columns do
          json.child! do
            json.name 'id'
            json.label 'ID'
            json.fixed 'left'
          end

          json.child! do
            json.name 'name'
            json.label AdminUser.human_attribute_name(:name)
            json.fixed 'left'
            json.searchable do
              json.type 'input-text'
              json.name 'name_cont'
              json.label AdminUser.human_attribute_name(:name)
              json.placeholder AdminUser.human_attribute_name(:name)
            end
          end

          json.child! do
            json.name 'email'
            json.label AdminUser.human_attribute_name(:email)
            json.searchable do
              json.type 'input-text'
              json.name 'email_cont'
              json.label AdminUser.human_attribute_name(:email)
              json.placeholder AdminUser.human_attribute_name(:email)
            end
          end

          json.child! do
            json.name 'super_admin'
            json.label AdminUser.human_attribute_name(:super_admin)
          end

          json.child! do
            json.name 'admin_role'
            json.label AdminUser.human_attribute_name(:admin_role)
          end

          json.child! do
            json.type 'operation'
            json.label '操作'
            json.width 140
            json.buttons do
              json.child! do
                json.type 'button'
                json.level 'link'
                json.icon 'fa fa-eye'
                json.tooltip '查看'
                json.actionType 'link'
                json.link '/admin_users/${id}'
              end

              json.child! do
                json.type 'button'
                json.level 'link'
                json.icon 'fa fa-pencil'
                json.tooltip '编辑'
                json.actionType 'link'
                json.link '/admin_users/${id}/edit'
              end

              json.child! do
                json.type 'button'
                json.level 'link'
                json.label '重置密码'
                json.actionType 'dialog'
                json.dialog do
                  json.title '重置密码'
                  json.body do
                    json.type 'form'
                    json.body do
                      json.child! do
                        json.type 'static'
                        json.name 'engine'
                        json.label 'Engine'
                      end

                      json.child! do
                        json.type 'divider'
                      end

                      json.child! do
                        json.type 'static'
                        json.name 'browser'
                        json.label 'Browser'
                      end

                      json.child! do
                        json.type 'divider'
                      end

                      json.child! do
                        json.type 'static'
                        json.name 'platform'
                        json.label 'Platform(s)'
                      end

                      json.child! do
                        json.type 'divider'
                      end

                      json.child! do
                        json.type 'static'
                        json.name 'version'
                        json.label 'Engine version(s)'
                      end

                      json.child! do
                        json.type 'divider'
                      end

                      json.child! do
                        json.type 'static'
                        json.name 'grade'
                        json.label 'CSS grade'
                      end

                      json.child! do
                        json.type 'divider'
                      end

                      json.child! do
                        json.type 'html'
                        json.html "<p>添加其他 <span>Html 片段</span> 需要支持变量替换（todo）.</p>"
                      end
                    end
                  end
                end
              end
            end

            json.toggled true
          end
        end
      end
    end
  end
end
