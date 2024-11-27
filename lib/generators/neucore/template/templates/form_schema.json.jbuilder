@breadcrumbs = amis_breadcrumb(['<%= resource.classify.underscore %>'])

@data = {}

@redirect = '/<%= resource.tableize %>' # 列表页

@fields = [
  amis_form_text(name: 'name', label: <%= resource.classify %>.human_attribute_name(:name), required: true)
]

json.partial! 'cms/shared/form'
