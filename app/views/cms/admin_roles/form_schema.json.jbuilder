@breadcrumbs = amis_breadcrumb(['user_management', 'admin_functions', 'admin_role'])

@data = {}

@redirect = '/admin_roles' # 列表页

@form_options = {wrapWithPanel: false}

admin_role_scopes = AdminRoleScope.all.collect{|admin_role_scope| {label: admin_role_scope.name, value: admin_role_scope.id}}

panel1 = {
  type: 'panel',
  title: I18n.t('forms.basic_information'),
  body: [
    amis_form_text(name: 'name', label: AdminRole.human_attribute_name(:name), required: true),
    amis_form_select(name: 'admin_role_scope_ids', label: AdminRole.human_attribute_name(:admin_role_scope), required: false, multiple: true, options: admin_role_scopes)
  ]
}

ps = []
AdminRole.load_permissions.each do |resource, actions|
  ps << amis_form_checkboxes(name: "permissions.#{resource}", label: I18n.t("permissions.#{resource}", default: resource.titleize), required: false, options: actions.collect{|p| {label: I18n.t("permissions.#{p}", default: p.titleize), value: p}})
end

panel2 = {
  type: 'panel',
  title: I18n.t('forms.permission_configuration'),
  body: ps
}

@fields = [panel1, panel2]
json.partial! 'cms/shared/form'
