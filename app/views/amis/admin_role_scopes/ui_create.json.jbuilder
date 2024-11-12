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
        json.label I18n.t('permissions.admin_role_scope')
      end

      json.child! do
        json.label I18n.t('add')
      end
    end
    json.style do
      json.set! 'margin-bottom', '12px'
    end
  end

  json.child! do
    json.type 'page'
    json.regions ["body", "toolbar", "header"]

    json.body do
      json.child! do
        json.type 'form'
        # json.static true
        json.api 'amis/admin_role_scopes'
        json.title '基本信息'
        json.mode 'horizontal'
        json.actions []
        json.body do
          json.child! do
            json.type 'input-text'
            json.name 'admin_role'
            json.label '角色'
            json.required true
          end

          json.child! do
            json.type 'input-text'
            json.name 'name'
            json.label '姓名'
            json.required true
          end

          json.child! do
            json.type 'input-text'
            json.name 'email'
            json.label '邮箱'
            json.required true
          end

          json.child! do
            json.type 'input-password'
            json.name 'password'
            json.label '密码'
            json.required true
          end

          json.child! do
            json.type 'submit'
            json.label '提交'
          end
        end
      end
    end
  end
end
