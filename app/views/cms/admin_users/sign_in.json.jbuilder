json.admin_user do
  json.extract! @object, :id, :name, :email, :access_token
end
