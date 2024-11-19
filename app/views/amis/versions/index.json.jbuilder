json.items @versions do |version|
  json.partial! "cms/versions/version", locals: { resource: @resource, version: version }
end

json.count @versions.total_count
json.page @versions.current_page