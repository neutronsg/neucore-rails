@breadcrumbs = amis_breadcrumb(['user_management', 'admin_role_scope'])

@data = {}

@headerToolbar = [
  amis_create_button, 
]

@columns = []
@columns << amis_id_column
@columns << amis_string_column(label: AdminRoleScope.human_attribute_name(:name), name: 'name', sortable: true).merge(searchable: amis_searchable(:name))
@columns << amis_string_column(label: AdminRoleScope.human_attribute_name(:scope), name: 'scope')

@operations = [amis_view_button, amis_edit_button]

@columns << amis_operation_base.merge(buttons: @operations)

json.partial! 'cms/shared/crud'
