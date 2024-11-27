@breadcrumbs = amis_breadcrumb(['user_management', 'admin_user'])

@data = {}

@toolbar = [amis_edit_button, amis_delete_button]

@panels = []

panel1 = {
  title: I18n.t('forms.basic_information'),
  body: {
    type: 'property',
    column: 2,
    items: [
      amis_text_property(label: AdminUser.human_attribute_name(:id), content: @object.id),
      amis_boolean_property(label: AdminUser.human_attribute_name(:super_admin), content: @object.super_admin),
      amis_text_property(label: AdminUser.human_attribute_name(:name), content: @object.name),
      amis_text_property(label: AdminUser.human_attribute_name(:email), content: @object.email),
      amis_links_property(label: AdminUser.human_attribute_name(:admin_roles), content: amis_custom_clickables(@object.admin_roles)),
    ]
  }
}

@panels = [panel1]

json.partial! 'cms/shared/view'
