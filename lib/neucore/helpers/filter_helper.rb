module Neucore
  module Helpers
    module FilterHelper
      def selection_filter model, options = {}
        if model.classify.constantize.new.respond_to?(:merchant_id) && current_admin_user.merchant_admin?
          records = model.classify.constantize.where(merchant_id: current_admin_user.merchant_id).all.order(default_order)
        else
          records = model.classify.constantize.all.order(default_order)
        end
        {
          name:I18n.t("filters.#{model}", default: model.titleize),
          type: 'select',
          query_name: "#{model}_id_eq",
          values: records.collect do |record|
            {
              name: record&.name || record.display_name,
              value: record.id
            }
          end
        }.merge(options)
      end

      def enum_filter(model, field)
        {
          name: I18n.t("filters.#{field}", default: field.titleize),
          type: 'select',
          query_name: "#{field}_eq",
          values: model.classify.constantize.send(field.tableize).collect do |key, value|
            {
              name: I18n.t("enums.#{model}.#{field.tableize}.#{key}", default: key.titleize),
              value: value
            }
          end
        }
      end

      def text_ml_filter field
        {
          name: I18n.t("filters.#{field}", default: field.titleize),
          type: 'text',
          query_name: "#{field}_ml_cont"
        }
      end

      def text_filter field
        {
          name: I18n.t("filters.#{field}", default: field.titleize),
          type: 'text',
          query_name: "#{field}_cont"
        }
      end

      def text_eq_filter field
        {
          name: I18n.t("filters.#{field}", default: field.titleize),
          type: 'text',
          query_name: "#{field}_eq"
        }
      end
    end
  end
end