json.type 'panel'
json.title  I18n.t('forms.history_information')
json.body do
  json.type 'crud'
  json.syncLocation false
  json.api "cms/versions?item_type=#{@object.class.name}&item_id=#{@object.id}"
  json.defaultParams do
    json.perPage 50
  end

  json.columns do
    json.child! do
      json.name 'id'
      json.label I18n.t("forms.id")
      json.width '100px'
    end

    json.child! do
      json.name 'changeset'
      json.label I18n.t("forms.changeset")
    end

    json.child! do
      json.label I18n.t("forms.created_at")
      json.type 'tpl'
      json.tpl "${DATETOSTR(created_at)}"
      json.width '180px'
    end

    json.child! do
      json.name 'operator'
      json.label I18n.t("forms.operator")
      json.width '180px'
    end
  end
end