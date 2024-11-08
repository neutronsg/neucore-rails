module Neucore
  module Helpers
    module AuditLog
      def format_version_change_text(resource, version, field, values)
        field_name = "#{I18n.t("activerecord.attributes.#{version.item_type.underscore}.#{field.delete_suffix('_id')}", default: nil) || I18n.t("activerecord.attributes.#{version.item_type.underscore}.#{field}", default: field)}"
        source = "#{get_field_text(version, field, values[0])}"
        dest = "#{get_field_text(version, field, values[1])}"
        if resource.class.name  == version.item_type
          "#{field_name} #{I18n.t('paper_trail.from', default: 'From')} #{source} #{I18n.t('paper_trail.to', default: 'To')} #{dest}"
        else
          item_name = format_version_change_item_name(version)
          "#{item_name}: #{field_name} #{I18n.t('paper_trail.from', default: 'From')} #{source} #{I18n.t('paper_trail.to', default: 'To')} #{dest}"
        end

      end

      def format_version_change_item_name(version)
        item = version.item
        "#{I18n.t("activerecord.models.#{version.item_type.underscore}", default: version.item_type.titleize)}: #{item.try(:custom_version_fields, version) || item.try(:name) || item.try(:display_name) || "ID#{item.try(:id)}"}"
      end

      def format_version_changeset(resource, version)
        if version.event == 'update'
          change_texts = version.changeset.map do |field, values|
            resource_name = resource.class.name.underscore
            if field == "#{resource_name}_id" && values[0].nil? && values[1] == resource.id
              ''
            elsif values[0].is_a?(Hash)
              nil
            else
              format_version_change_text(resource, version, field, values)
            end
          end
          raw change_texts.compact.join("<br />")
        else
          raw "#{I18n.t("paper_trail.events.#{version.event}", default: version.event.titleize)} #{format_version_change_item_name(version)}"
        end
      end

      private
      def get_field_text(version, field, value)
        if value.present?
          association_name = field.delete_suffix('_id').split('_').map(&:capitalize).join
          association_class = association_name.constantize rescue nil
          if field.end_with?('_id') && association_class.present?
            association = association_class.find_by_id(value)
            if association.present?
              association.try(:name) || association.try(:display_name) || "ID#{value}"
            else
              "ID#{value}(#{I18n.t('paper_trail.destroyed', default: 'Deleted')})"
            end
          elsif value.try(:end_with?, '.jpg') || value.try(:end_with?, '.jpeg') || value.try(:end_with?, '.png')
            if value.try(:start_with, 'http')
              image_tag(value, width: '120')
            else
              if version.item.send(field).blank?
                I18n.t('paper_trail.empty', default: 'Empty')
              else
                version.item.send(field).retrieve_from_store!(value)
                image_tag(version.item.send(field).versions[:small].try(:url) || version.item.send(field).try(:url), width: '120')
              end
            end
          else
            I18n.t("activerecord.attributes.#{version.item_type.underscore}.#{field.pluralize}.#{value}", default: nil) || value
          end
        else
          I18n.t('paper_trail.empty', default: 'Empty')
        end
      end
    end
  end
end