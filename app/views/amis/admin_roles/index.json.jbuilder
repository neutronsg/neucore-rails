json.count @objects.total_count
json.page @objects.current_page

json.rows @objects do |object|
  json.extract! object, :id, :name
  # json.admin_role_scopes custom_clickables(object.admin_role_scopes)
  json.admin_role_scopes 'Admin Role Scopes'
  json.permissions object.permissions_text
end