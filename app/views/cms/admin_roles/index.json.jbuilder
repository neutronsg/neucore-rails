actions = []
actions << create_action('admin_roles') if can?(:create, AdminRole)

json.actions actions

json.objects @objects do |object|
  json.extract! object, :id, :name
  json.admin_role_scope custom_clickable(object.admin_role_scope)
  json.permissions object.permissions_text

  json.member_actions do
    json.partial! 'cms/member_actions/defaults', locals: {actions: default_member_actions(%w(view edit), 'admin_roles')}
  end
end

json.partial! "cms/setups/column_titles", locals: {
  columns: %w(id name admin_role_scope permissions),
  model_name: "admin_role"
}

filters = [
  text_filter('name'),
]
json.filters filters

json.pagination pagination(@objects)

json.partial! "cms/setups/scopes", locals: {scopes: %w()}
