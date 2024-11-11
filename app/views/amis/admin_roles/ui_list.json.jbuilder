json.type 'wrapper'
json.style do
  json.padding '0'
end

json.body do
  json.child! do
    json.type 'breadcrumb'
    json.items do
      json.child! do
        json.label '设置'
      end

      json.child! do
        json.label '管理员'
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
        json.label '新增'
        json.icon 'fa fa-plus pull-left'
        json.primary true
        json.actionType 'link'
        json.link '/admin_roles/create'
      end
    end
    json.body do
      json.child! do
        json.type 'crud'
        json.draggable true
        json.api 'amis/admin_roles'
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
            json.label '姓名'
            json.fixed 'left'
            json.searchable do
              json.type 'input-text'
              json.name 'name_cont'
              json.label '名称'
              json.placeholder '名称'
            end
          end

          json.child! do
            json.name 'admin_role_scopes'
            json.label 'Admin Role Scopes'
          end

          json.child! do
            json.name 'permissions'
            json.label 'permissions'
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
                json.link '/admin_roles/${id}'
              end

              json.child! do
                json.type 'button'
                json.level 'link'
                json.icon 'fa fa-pencil'
                json.tooltip '编辑'
                json.actionType 'link'
                json.link '/admin_roles/${id}/edit'
              end
            end

            json.toggled true
          end
        end
      end
    end
  end
end
