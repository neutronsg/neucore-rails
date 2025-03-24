json.type 'panel'
json.title  I18n.t('forms.history_information')
json.body do
  json.type 'crud'
  json.syncLocation false
  json.api "cms/versions?item_type=#{@object.class.name}&item_id=#{@object.id}"
  json.defaultParams do
    json.perPage 50
  end

  columns = []
  columns << amis_id_column
  columns << amis_html_column(label: I18n.t("forms.changeset"), name: 'changeset')
  columns << amis_datetime_column(label: I18n.t("forms.created_at"), name: 'created_at')
  columns << amis_string_column(label: I18n.t("forms.operator"), name: 'operator')


  json.columns columns
end