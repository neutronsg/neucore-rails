@breadcrumbs = amis_breadcrumb(['<%= resource.classify.underscore %>'])

@data = {
  id: @object.id,
  permissions: default_member_permissions(@object)
}

@toolbar = [amis_edit_button, amis_delete_button]

@panels = []

panel1 = {
  title: I18n.t('forms.basic_information'),
  body: {
    type: 'form',
    wrapWithPanel: false,
    columnCount: 3,
    body: [
      amis_static_text(label: <%= resource.classify %>.human_attribute_name(:id), value: @object.id),
      amis_static_text(label: <%= resource.classify %>.human_attribute_name(:name), value: @object.name),
      amis_static_datetime(label: <%= resource.classify %>.human_attribute_name(:created_at), value: @object.created_at)
    ].flatten
  }
}

@panels = [panel1]
@versions = true

json.partial! 'cms/shared/view'
