json.version 1
json.action_config do
  if @action_name == 'create'
    json.url "cms/#{@resource.underscore.pluralize}"
    json.method "POST"
  else
    json.url "cms/#{@resource.underscore.pluralize}/#{@object.id}"
    json.method "PUT"
  end
  
  if %w(images).include?(@resource)
    json.headers do
      json.set! 'Content-Type', 'multipart/form-data'
    end
  end
end

json.resource_config do
  json.url 'cms/forms/simple_list'
  json.response_data_path 'data.objects'
  json.method 'GET'
  json.label_key 'name'
  json.value_key 'id'
end

if @object.present?
  json.attributes do 
    json.partial! "cms/#{@resource}/attributes"
  end
else
  json.attributes nil
end

json.ui do 
  json.form do 
    json.labelCol nil
    json.wrapperCol nil
    json.labelWidth '180'
    json.wrapperWidth 'auto'
    json.labelAlign 'left'
    json.labelWrap true
  end

  json.schema do
    json.type 'object'
    json.properties do
      json.void do
        json.type 'void'
        json.set! 'x-component', 'FormCollapse'
        json.set! 'x-component-props' do
          json.formCollapse "{{formCollapse}}"
        end
        json.properties do 
          json.partial! "cms/#{@resource}/form_ui"
        end
        json.set! 'x-index', 0
      end
    end
  end
end
