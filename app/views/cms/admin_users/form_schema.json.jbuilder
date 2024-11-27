@breadcrumbs = amis_breadcrumb(['user_management', 'admin_user'])

@data = {}

if @type == 'edit' || @type == 'view'
  @data[:name] = @object.name
  @data[:email] = @object.email
  @data[:admin_role_ids] = @object.admin_role_ids
end

@redirect = '/admin_users' # 列表页

@fields = [
  amis_form_switch(name: 'super_admin', label: AdminUser.human_attribute_name(:super_admin), required: true, value: false),
  amis_form_text(name: 'name', label: AdminUser.human_attribute_name(:name), required: true),
  amis_form_text(name: 'email', label: AdminUser.human_attribute_name(:email), required: true),
]

@fields << amis_form_text(name: 'password', label: User.human_attribute_name(:password), required: true, type: "input-password") if @type == 'create'
@fields << amis_form_select(name: 'admin_role_ids', label: User.human_attribute_name(:admin_role), required: false, multiple: true, options: amis_select_options('AdminRole'), visibleOn: "${!super_admin}")

json.partial! 'cms/shared/form'
