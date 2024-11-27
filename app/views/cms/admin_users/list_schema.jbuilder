@breadcrumbs = amis_breadcrumb(['user_management', 'admin_user'])

@data = {
  permissions: create_permission('AdminUser')
}

@headerToolbar = [amis_create_button]

@columns = []
@columns << amis_id_column
@columns << amis_string_column(label: AdminUser.human_attribute_name(:super_admin), name: 'super_admin')
@columns << amis_string_column(label: AdminUser.human_attribute_name(:name), name: 'name', sortable: true).merge(searchable: amis_searchable(:name))
@columns << amis_string_column(label: AdminUser.human_attribute_name(:email), name: 'email').merge(searchable: amis_searchable(:email))
@columns << amis_clickables_column(label: AdminUser.human_attribute_name(:admin_roles), name: 'admin_roles')

@operations = [amis_view_button, amis_edit_button, amis_delete_button]

reset_password = {
  type: 'button',
  label: I18n.t('actions.reset_password'),
  tooltip: I18n.t('actions.reset_password'),
  actionType: 'dialog',
  level: 'link',
  dialog: {
    title: I18n.t('actions.reset_password'),
    body: [
      {
        type: 'form',
        api: "cms/users/${id}/reset_password",
        body: [
          amis_form_text(name: 'password', label: AdminUser.human_attribute_name(:password), required: true, type: 'input-password'),
          amis_form_text(name: 'password_confirmation', label: AdminUser.human_attribute_name(:password_confirmation), required: true, type: 'input-password'),
        ]
      }
    ]
  }
}

@operations << reset_password
@columns << amis_operation_base.merge(buttons: @operations)

json.partial! 'cms/shared/crud'
