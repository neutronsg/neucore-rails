json.count @objects.total_count
json.page @objects.current_page

json.rows @objects do |object|
  json.extract! object, :id, :name, :email, :super_admin
  json.admin_roles amis_custom_clickables(object.admin_roles)
  json.permissions default_member_permissions(object)
end