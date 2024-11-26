@breadcrumbs = amis_breadcrumb(['<%= resource.classify.underscore %>'])

@data = {}

if @type == 'edit'
  @data[:name] = @object.name
end

@redirect = '/<%= resource.tableize %>' # 列表页

@fields = [
  amis_form_text(name: 'name', label: <%= resource.classify %>.human_attribute_name(:name), required: true)
]

json.partial! 'amis/shared/form'
