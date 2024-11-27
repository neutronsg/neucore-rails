@breadcrumbs = amis_breadcrumb(['user_management', 'admin_functions', 'admin_role'])

@data = {
  permissions: create_permission('AdminRole')
}

@toolbar = [amis_create_button]

@columns = []
@columns << amis_id_column
@columns << amis_string_column(label: AdminRole.human_attribute_name(:name), name: 'name', sortable: true).merge(searchable: amis_searchable(:name))
@columns << amis_string_column(label: AdminRole.human_attribute_name(:admin_role_scope), name: 'admin_role_scopes')
@columns << amis_html_column(label: AdminRole.human_attribute_name(:permissions), name: 'permissions_text')

@operations = [amis_view_button, amis_edit_button, amis_delete_button]

@columns << amis_operation_base.merge(buttons: @operations)

json.partial! 'cms/shared/crud'
