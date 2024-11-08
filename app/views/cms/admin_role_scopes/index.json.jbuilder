actions = []
actions << create_action('admin_role_scopes') if can?(:create, AdminRoleScope)

json.actions actions

json.objects @objects do |object|
  json.extract! object, :id, :name, :scope

  json.member_actions do
    json.partial! 'cms/member_actions/defaults', locals: {actions: default_member_actions(%w(view edit), 'admin_role_scopes')}
  end
end

json.partial! "cms/setups/column_titles", locals: {
  columns: %w(id name scope),
  model_name: "admin_role_scope"
}

filters = [
  text_filter('name'),
]
json.filters filters

json.pagination pagination(@objects)

json.partial! "cms/setups/scopes", locals: {scopes: %w()}
