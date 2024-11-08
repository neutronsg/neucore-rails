json.extract! @object, :id, :name, :email, :super_admin
json.extract! @object, *AdminRoleScope.scopes(AdminUser)
json.admin_role_id @object.admin_role_ids&.first