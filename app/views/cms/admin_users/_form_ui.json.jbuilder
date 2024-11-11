json.basic_information do
  json.set! 'x-index', 0
  json.type 'void'
  json.set! 'x-component', 'FormCollapse.Item'
  json.set! 'x-component-props' do
    json.title I18n.t('forms.basic_information')
  end
  
  json.properties do
    index = -1
    json.super_admin switch_ui(title: AdminUser.human_attribute_name(:super_admin), index: index+=1, disabled: updating?)
    reaction = {
      dependencies: ['.super_admin'],
      fulfill: {
        state: {
          visible: '{{!$deps[0]}}'
        }
      }
    }
    json.admin_role_id fselect_ui(title: AdminUser.human_attribute_name(:admin_role), index: index+=1, resource: 'admin_roles', required: true, multiple: false, 'x-reactions': [reaction])
    AdminRoleScope.scopes(AdminUser).each do |scope|
      scope = scope.to_s
      json.set! scope, fselect_ui(title: AdminUser.human_attribute_name(scope), index: index+=1, resource: scope.titlecase.tableize, required: false, multiple: false, 'x-reactions': [reaction])
    end
    json.name string_ui(title: AdminUser.human_attribute_name(:name), index: index+=1, required: true)
    json.email string_ui(title: AdminUser.human_attribute_name(:email), index: index+=1, required: true)
    json.password string_ui(title: AdminUser.human_attribute_name(:password), component: 'Password', required: true, visible: @action_name == 'create', index: index+=1)
  end
end
