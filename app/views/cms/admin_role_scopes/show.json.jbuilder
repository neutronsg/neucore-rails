json.object do
  json.title "#{I18n.t("activerecord.models.#{@object.class.name.underscore}", default: @object.class.name)}: #{@object.id}"
  json.member_actions do
    json.partial! "cms/member_actions/defaults", locals: {actions: default_member_actions(%w(edit), 'admin_role_scopes')}
  end

  json.sections do
    json.child! do
      json.title I18n.t("forms.basic_information")
      json.data do
        json.extract! @object, :id, :name, :scope
        json.created_at format_time(@object.created_at)
      end
      json.partial! "cms/setups/column_titles", locals: {
        columns: %w(id name scope created_at),
        model_name: "admin_role_scope"
      }
    end
  end
end
