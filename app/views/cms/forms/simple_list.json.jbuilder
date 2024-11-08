json.objects @objects do |object|
  json.extract! object, :id, :name
end
