json.basic_information do
  json.set! 'x-index', 0
  json.type 'void'
  json.set! 'x-component', 'FormCollapse.Item'
  json.set! 'x-component-props' do
    json.title I18n.t('forms.basic_information')
  end
  
  json.properties do
    index = -1
    json.name formily_string(title: AdminRole.human_attribute_name(:name), index: index+=1, required: true)
    json.admin_role_scope_ids formily_fselect(title: AdminRole.human_attribute_name(:admin_role_scope), index: index+=1, resource: 'admin_role_scopes', required: false, multiple: true)
  end
end

json.permission_configuration do
  json.set! 'x-index', 1
  json.type 'void'
  json.set! 'x-component', 'FormCollapse.Item'
  json.set! 'x-component-props' do 
    json.title I18n.t('forms.permission_configuration')
  end

  json.properties do
    index = -1
    json.permissions do
      json.type 'object'
      json.properties do
        AdminRole.load_permissions.each do |permission, permissions|
          title = I18n.t("permissions.#{permission}", default: permission.titleize)
          enum = permissions.collect{|p| {name: I18n.t("permissions.#{p}", default: p.titleize), id: p}}
          json.set! permission, formily_fcheckbox(title: title, index: index+=1, enum: enum)
        end
      end
    end
  end
end