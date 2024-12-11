@breadcrumbs = amis_breadcrumb(['user_management', 'admin_user'])

@data = {}

@toolbar = [amis_edit_button, amis_delete_button]

@panels = []

panel1 = {
  title: I18n.t('forms.basic_information'),
  body: {
    type: 'form',
    wrapWithPanel: false,
    columnCount: 3,
    body: [
      amis_static_text(label: AdminUser.human_attribute_name(:id), value: @object.id),
      amis_static_text(label: AdminUser.human_attribute_name(:super_admin), value: @object.super_admin),
      amis_static_text(label: AdminUser.human_attribute_name(:name), value: @object.name),
      amis_static_text(label: AdminUser.human_attribute_name(:email), value: @object.email),
      amis_static_datetime(label: AdminUser.human_attribute_name(:created_at), value: @object.created_at)
    ].flatten
  }
}

@panels = [panel1]

json.partial! 'cms/shared/view'
