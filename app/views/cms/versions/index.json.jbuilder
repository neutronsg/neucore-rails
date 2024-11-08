json.versions @versions do |version|
  json.partial! "cms/versions/version", locals: { resource: @resource, version: version }
end
