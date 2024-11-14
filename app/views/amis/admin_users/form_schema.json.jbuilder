json.type 'wrapper'
json.style do
  json.padding '0'
end

json.body do
  json.child! do
    json.merge! amis_breadcrumb(['settings', 'admin_user'])
  end

  json.child! do
    json.type 'page'
    if @type == 'view' || @type == 'edit'
      json.data do
        json.extract! @object, :id, :name, :email, :super_admin
        json.admin_role 'admin_role'
      end
    end

    json.body do
      json.child! do
        json.merge! amis_form_base

        fields = []
        fields << amis_string(name: 'name', label: AdminUser.human_attribute_name(:name), required: true)
        fields << amis_string(name: 'admin_role', label: AdminUser.human_attribute_name(:admin_role), required: true)
        fields << amis_string(name: 'email', label: AdminUser.human_attribute_name(:email), required: true)
        fields << amis_string(type: 'input-password', name: 'password', label: AdminUser.human_attribute_name(:password), required: true)

        if @type == 'edit' || @type == 'create'
          fields << {type: 'submit', label: '提交'}
        end
        json.body fields
      end
    end
  end
end
