module Neucore
  module Versionable
    extend ActiveSupport::Concern
    @associations ||= {}

    def self.add(class_name, attribute)
      @associations[class_name] << attribute
    end

    def self.init_class(class_name)
      @associations[class_name] ||= []
    end

    def self.get(class_name)
      @associations[class_name]
    end

    included do
      Versionable.init_class(name)
    end

    class_methods do
      def version_include(*association_names)
        Versionable.init_class(name)
        association_names.each do |association_name|
          Versionable.add(name, association_name)
        end
      end
    end

    def related_versions
      return unless Versionable.get(self.class.name)
      versions = PaperTrail::Version.includes(:item).where(item_type: self.class.name, item_id: id)
      Versionable.get(self.class.name).each do |association_name|
        association_name = association_name.to_s.split('_').map(&:capitalize).join
        if association_name.pluralize.singularize == association_name
          versions = versions.or(PaperTrail::Version.where(item_type: association_name, item_id: send(association_name.underscore).id))
        else
          versions = versions.or(PaperTrail::Version.where(item_type: association_name.singularize, item_id: send(association_name.underscore).pluck(:id)))
        end
      end
      versions.reorder(created_at: :desc)
    end
  end
end