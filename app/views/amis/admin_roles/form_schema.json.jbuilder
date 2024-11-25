@breadcrumbs = amis_breadcrumb(['user_management', 'admin_functions', 'admin_role'])

@data = {}

if @type == 'edit'
  @data[:name] = @object.name
end

@redirect = '/admin_roles' # 列表页

@fields = [
  amis_form_text(name: 'name', label: AdminRole.human_attribute_name(:name), required: true)
]

json.partial! 'amis/shared/form'
