@breadcrumbs = amis_breadcrumb(['<%= resource.classify.underscore %>'])

@data = {id: @object.id}

@toolbar = [
  amis_edit_button,
]

@panels = []

panel1 = {
  title: I18n.t('forms.basic_information'),
  body: {
    type: 'property',
    column: 2,
    items: [
      amis_text_property(label: <%= resource.classify %>.human_attribute_name(:id), content: @object.id),
      amis_text_property(label: <%= resource.classify %>.human_attribute_name(:name), content: @object.name),
    ]
  }
}

@panels = [panel1]
@versions = true

json.partial! 'amis/shared/view'
