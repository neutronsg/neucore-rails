@breadcrumbs = amis_breadcrumb(['<%= resource.classify.underscore %>'])

@data = {
  permissions: create_permission('<%= resource.classify %>')
}

@headerToolbar = [amis_create_button]

@columns = []
@columns << amis_id_column
@columns << amis_string_column(label: <%= resource.classify %>.human_attribute_name(:name), name: 'name', sortable: true, searchable: amis_text_filter(name: 'name'))

@operations = [amis_view_button, amis_edit_button, amis_delete_button]

@columns << amis_operation_base.merge(buttons: @operations)

json.partial! 'cms/shared/crud'
