json.count @objects.total_count
json.page @objects.current_page

json.rows @objects do |object|
  json.extract! object, :id, :name
  json.admin_role_scopes object.admin_role_scopes.map(&:name)
  json.permissions_text object.permissions_text
  json.permissions default_member_permissions(object)
end