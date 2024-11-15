json.type 'wrapper'
json.style do
  json.padding '0'
end

json.body do
  json.child! do
    json.merge! amis_breadcrumb(['users', 'example'])
  end

  json.child! do
    json.type 'page'
    json.toolbar do
      json.type 'container'
      json.style do
        json.padding '12px 12px 0 12px'
      end

      json.body amis_create_button
    end
    json.body [@test_json]
  end
end
