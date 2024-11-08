json.object do
  json.title "#{I18n.t("activerecord.models.#{@object.class.name.underscore}", default: @object.class.name)}: #{@object.id}"
  json.member_actions do
    json.partial! "cms/member_actions/defaults", locals: {actions: default_member_actions(%w(edit), 'admin_users')}
    
    custom_actions = []
    if can?(:update, AdminUser)
      custom_actions = [{
        name: I18n.t('actions.reset_password'), 
        path: "cms/admin_users/#{@object.id}/reset_password", 
        method: 'POST', 
        extra_params: reset_password_extra_params
      }]
    end
    json.custom_actions custom_actions
  end

  json.sections do
    json.child! do
      json.title I18n.t("forms.basic_information")
      json.data do
        json.extract! @object, :id, :name, :email, :super_admin
        json.admin_role custom_clickables(@object.admin_roles)
        json.created_at format_time(@object.created_at)
      end
      json.partial! "cms/setups/column_titles", locals: {
        columns: %w(id name super_admin admin_role email created_at),
        model_name: "admin_user"
      }
    end
  end
end
