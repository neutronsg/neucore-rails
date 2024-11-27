@breadcrumbs = amis_breadcrumb(['user_management', 'admin_role_scope'])

@data = {}

if @type == 'edit' || @type == 'view'
  @data[:name] = @object.name
  @data[:scope] = @object.scope
end

@redirect = '/admin_role_scopes' # 列表页

@fields = [
  amis_form_text(name: 'name', label: AdminRoleScope.human_attribute_name(:name), required: true),
  amis_form_select(name: 'scope', label: AdminRoleScope.human_attribute_name(:scope), required: true, options: AdminRoleScope::SCOPES.collect{|s| {label: s, value: s}})
]

json.partial! 'cms/shared/form'
