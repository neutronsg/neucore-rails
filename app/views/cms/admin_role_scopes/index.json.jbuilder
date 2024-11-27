json.count @objects.total_count
json.page @objects.current_page

json.rows @objects do |object|
  json.extract! object, :id, :name, :scope
  json.permissions default_member_permissions(object)
end