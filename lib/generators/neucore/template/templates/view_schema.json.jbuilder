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
    type: 'property',
    column: 2,
    items: [
      amis_number_property(label: <%= resource.classify %>.human_attribute_name(:id), content: @object.id),
      amis_text_property(label: <%= resource.classify %>.human_attribute_name(:name), content: @object.name),
    ]
  }
}

@panels = [panel1]
@versions = true

json.partial! 'cms/shared/view'
