json.count @objects.total_count
json.page @objects.current_page

json.rows @objects do |object|
  json.extract! object, :id, :name, :scope
end