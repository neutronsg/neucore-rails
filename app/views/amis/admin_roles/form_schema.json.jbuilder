json.type 'wrapper'
json.style do
  json.padding '0'
end

json.body do
  json.child! do
    json.merge! amis_breadcrumb(['settings', 'admin_role'])
  end

  json.child! do
    json.type 'page'
    if @type == 'view' || @type == 'edit'
      json.data do
        json.extract! @object, :id, :name
      end
    end

    json.body do
      json.child! do
        json.merge! amis_form_base

        fields = []
        fields << amis_form_text(name: 'name', label: AdminRole.human_attribute_name(:name), required: true)

        if @type == 'edit' || @type == 'create'
          fields << {type: 'submit', label: '提交'}
        end
        json.body fields
      end
    end
  end
end
