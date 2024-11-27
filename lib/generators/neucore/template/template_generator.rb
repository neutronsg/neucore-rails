# frozen_string_literal: true
require "rails/generators"
require "rails/generators/active_record"
# rails g neucore:template Resource
class Neucore::TemplateGenerator < Rails::Generators::Base
  source_root File.expand_path("templates", __dir__)
  argument :resource, type: :string, default: "Template"

  def copy_files
    @resource = resource
    template 'template.rb', File.join('app/models', "#{resource.underscore}.rb")
    template 'template_controller.rb', File.join('app/controllers/cms', "#{resource.tableize}_controller.rb")
    template 'template.en.yml', File.join('config/locales/en', "#{resource.classify.underscore}.yml")
    template 'template.cn.yml', File.join('config/locales/zh_cn', "#{resource.classify.underscore}.yml")
    template 'form_schema.json.jbuilder', File.join("app/views/cms/#{resource.tableize}", "form_schema.json.jbuilder")
    template 'index.json.jbuilder', File.join("app/views/cms/#{resource.tableize}", "index.json.jbuilder")
    template 'list_schema.json.jbuilder', File.join("app/views/cms/#{resource.tableize}", "list_schema.json.jbuilder")
    template 'view_schema.json.jbuilder', File.join("app/views/cms/#{resource.tableize}", "view_schema.json.jbuilder")
    template 'migration.rb', File.join("db//migrate", "#{Time.now.strftime("%Y%m%d%H%M%S")}_create_#{resource.tableize}.rb")
  end
end
