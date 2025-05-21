module Neucore
  module Helpers
    module Cms
      def create_action model
        {
          name: I18n.t('actions.create'),
          action: 'navigation',
          path: "#{model}/create"
        }
      end

      def default_order
        "deleted_at desc, id desc"
      end

      def updating?
        @action_name == 'update'
      end

      def reset_password_extra_params
        [
          {name: I18n.t('activerecord.attributes.admin_user.password'), key: 'password', type: :text, value: ''},
          {name: I18n.t('activerecord.attributes.admin_user.password_confirmation'), key: 'password_confirmation', type: :text, value: ''}
        ]
      end

      def default_member_permissions object
        permissions = []
        permissions << 'read' if can?(:read, object)
        permissions << 'update' if can?(:update, object) && !object.deleted?
        permissions << 'destroy' if can?(:destroy, object) && !object.deleted?
        permissions << 'restore' if can?(:destroy, object) && object.deleted?

        permissions
      end

      def create_permission model
        can?(:create, model.classify.constantize) ? ['create'] : []
      end

      def custom_clickable object
        return unless object.present?
        return object.display_deleted_name if object.deleted?
        clickables = []
        clickables << {model_name: object.class.name.tableize, id: object.id, name: object.display_name} if object
        {clickables: clickables}
      end

      def custom_clickables objects
        clickables = []
        objects&.each do |object|
          model_name = object.class.name.tableize
          clickables << {model_name: model_name, id: object.id, name: object.display_name}
        end
        {clickables: clickables}
      end

      def number_to_currency(number, options = { unit: 'S$' })
        if options[:unit].nil?
          options[:unit] = ''
        end
        super(number, options)&.to_s&.strip
      end

      def display_product_price(product)
        if product.price_low == product.price_high
          number_to_currency(product.price_low)
        else
          "#{number_to_currency(product.price_low)} - #{number_to_currency(product.price_high)}"
        end
      end

      def enum_values model, enums
        model.classify.constantize.send(enums).keys.collect{|enum| { label: I18n.t("enums.#{model}.#{enums}.#{enum}", default: enum.titleize), value: enum }}
      end

      def enum_weekday
        enums = []
        %w(Sun Mon Tue Wed Thu Fri Sat).each_with_index do |name, id|
          enums << {name: name, id: id}
        end
        enums
      end

      def human_days_of_week days
        return '' unless days.present?
        result = []
        days.each do |day|
          result << %w(Sun Mon Tue Wed Thu Fri Sat)[day]
        end
        result.join(",")
      end

      def default_member_actions actions = [], model = ''
        model = model.classify.constantize
        result = []
        actions.each do |action|
          result << action if action == 'view' && can?(:read, model)
          result << action if action == 'edit' && can?(:update, model)
          result << action if action == 'destroy' && can?(:destroy, model)
          result << action if action == 'restore' && can?(:destroy, model)
        end
        result
      end

      def batch_actions_for(model = 'products', confirmation = nil)
        constantize = model.classify.constantize
        batch_actions = []
        if params[:scope] == "active" && current_admin_user.can?(:update, constantize)
          batch_actions << {name: I18n.t("actions.batch_deactivate"), method: "POST", path: "cms/#{model}/batch_deactivate", confirmation: confirmation || I18n.t("actions.batch_deactivate_confirmation")}
        end

        if params[:scope] == "inactive" && current_admin_user.can?(:update, constantize)
          batch_actions << {name: I18n.t("actions.batch_activate"), method: "POST", path: "cms/#{model}/batch_activate", confirmation: confirmation || I18n.t("actions.batch_activate_confirmation")}
        end

        if params[:scope] == 'only_deleted' && current_admin_user.can?(:destroy, constantize)
          batch_actions << { name: I18n.t('actions.batch_restore'), method: 'POST', path: "cms/#{model}/batch_restore", confirmation: I18n.t('actions.batch_restore_confirmation') }
        end

        if params[:scope] != 'only_deleted' && current_admin_user.can?(:destroy, constantize)
          batch_actions << {name: I18n.t("actions.batch_delete"), method: "POST", path: "cms/#{model}/batch_delete", confirmation: I18n.t("actions.batch_delete_confirmation")}
        end

        batch_actions
      end

      def readabletime time
        return "" if time.nil?

        if time.is_a?(Date)
          time = time.to_time.to_i
        elsif time.is_a?(Time)
          time = time.to_i
        end
        now = Time.now.to_i

        if time > now
          t = Time.at(time).strftime("%Y-%m-%d %H:%M:%S")
          t.gsub!("00:00:00", "")
          t.strip!
          t
        elsif time + 60 > now
          'Just Now'
        elsif time + 3600 > now
          "#{(now - time) / 60} minutes ago"
        elsif time + 3600 * 24 > now
          "#{(now - time) / 3600} hours ago"
        elsif time + 3600 * 24 * 7 > now
          d = (now - time) / 3600 / 24
          d == 1 ? "1 day ago" : "#{d} days ago"
        else
          time = Time.at(time)
          now = Time.at(now)
          if time.year == now.year
            time.strftime("%-d %b")
          else
            time.strftime("%-d %b, %Y")
          end
        end
      end
    end
  end
end