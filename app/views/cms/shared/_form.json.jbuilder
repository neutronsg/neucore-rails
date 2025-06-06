form_options = @form_options || {}
actions = []
if @type == 'edit' || @type == 'create'
  actions << {type: 'button', label: I18n.t('cancel'), size: 'sm', onEvent: {click: {actions: [{actionType: 'goBack'}]}}}
  actions << {type: 'reset', label: I18n.t('reset'), size: "sm"}
  actions << {type: 'submit', label: I18n.t('submit'), level: 'primary', size: "sm"}
end

json.type 'wrapper'
json.className 'form'
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
      if @type == 'edit' && File.exist?("#{Rails.root}/app/views/#{Neucore.configuration.cms_path}/#{@resource}/_attributes.json.jbuilder")
        json.partial! "#{Neucore.configuration.cms_path}/#{@resource}/attributes"
      end
      json.merge! @data || {}
    end

    json.body do
      json.child! do
        json.merge! amis_form_base(**form_options)
        json.redirect @redirect

        json.body @fields

        json.actions actions
      end
    end
  end
end
