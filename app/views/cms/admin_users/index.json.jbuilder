actions = []
actions << create_action('admin_users') if can?(:create, AdminUser)

json.actions actions

json.objects @objects do |object|
  json.extract! object, :id, :name, :email, :super_admin
  json.admin_role custom_clickables(object.admin_roles)

  json.member_actions do
    json.partial! 'cms/member_actions/defaults', locals: {actions: default_member_actions(%w(view edit), 'admin_users')}
    
    custom_actions = []
    if can?(:update, AdminUser)
      custom_actions = [{
        name: I18n.t('actions.reset_password'), 
        path: "cms/admin_users/#{object.id}/reset_password", 
        method: 'POST', 
        extra_params: reset_password_extra_params
      }]
    end
    json.custom_actions custom_actions
  end
end

json.partial! "cms/setups/column_titles", locals: {
  columns: %w(id name super_admin admin_role email),
  model_name: "admin_user"
}

filters = [
  text_filter('name'),
  text_filter('email')
]
json.filters filters

json.pagination pagination(@objects)

json.partial! "cms/setups/scopes", locals: {scopes: %w()}
