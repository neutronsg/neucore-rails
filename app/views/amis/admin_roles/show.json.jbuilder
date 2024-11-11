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
    json.title '管理员详情'
    json.regions ["body", "toolbar", "header"]
    json.initApi "/amis/admin_roles/1"
    json.data do
      json.extract! @object, :id, :name
    end

    json.body do
      json.child! do
        json.type 'form'
        json.static true
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
        end
      end
    end
  end
end
