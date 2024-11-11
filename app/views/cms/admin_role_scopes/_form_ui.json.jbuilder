json.basic_information do
  json.set! 'x-index', 0
  json.type 'void'
  json.set! 'x-component', 'FormCollapse.Item'
  json.set! 'x-component-props' do
    json.title I18n.t('forms.basic_information')
  end
  
  json.properties do
    index = -1
    json.name formily_string(title: AdminRoleScope.human_attribute_name(:name), index: index+=1, required: true)
    json.scope formily_enum(title: AdminRoleScope.human_attribute_name(:scope), index: index+=1, required: true, enum: AdminRoleScope::SCOPES.collect{|s| {label: s, value: s}})
    reaction = {
      dependencies: ['.scope'],
      fulfill: {
        schema: {
          'x-component-props': {
            params: {
              resource: '{{$deps[0]}}'
            }
          }
        },
        state: {
          visible: '{{!!$deps[0]}}'
        },
      }
    }
    json.scope_ids formily_fselect(title: AdminRoleScope.human_attribute_name(:scope_ids), index: index+=1, required: false, 'x-component-props' => {requiredParams: ['resource']}, multiple: true, 'x-reactions': [reaction])
  end
end
