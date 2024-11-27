form_options = @form_options || {}

json.type 'wrapper'
json.style do
  json.padding '0'
end

json.body do
  json.child! do
    json.merge! @breadcrumbs
  end if @breadcrumbs

  json.child! do
    json.type 'page'
    json.data do
      json.merge! @data || {}
    end

    json.body do
      json.child! do
        json.merge! amis_form_base(**form_options)

        json.redirect @redirect

        if @type == 'edit' || @type == 'create'
          @fields << {type: 'reset', label: 'Reset'}
          @fields << {type: 'submit', label: '提交'}
        end
        json.body @fields
      end
    end
  end
end
