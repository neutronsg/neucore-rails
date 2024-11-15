require_relative 'amis_ui/column'

module Neucore
  module Helpers
    module AmisUi
      include Column
      def amis_form_base
        schema = {
          type: 'form',
          static: @type == 'view',
          api: amis_api,
          title: I18n.t("forms.basic_information"),
          mode: 'horizontal',
          actions: []
        }
        schema
      end

      def amis_crud_scopes scopes
        scopes = scopes.collect{|scope| {label: I18n.t(scope, default: scope.titleize), value: scope}}
        schema = {
          type: 'button-group-select',
          name: 'type',
          options: scopes,
          onEvent: {
            change: {
              actions: [
                {
                  componentId: 'crud',
                  actionType: 'reload',
                  data: {
                    scope: "${event.data.value}"
                  }
                }
              ]
            }
          }
        }
        schema
      end

      def amis_crud_tabs tabs
        tabs = tabs.collect{|tab| {title: I18n.t(tab, default: tab.titleize)}}
        schema = {
          type: 'tabs',
          mode: 'line',
          tabs: tabs,
          onEvent: {
            change: {
              actions: [
                {
                  componentId: 'crud',
                  actionType: 'reload',
                  data: {
                    scope: "${scopes[event.data.value - 1]}"
                  }
                }
              ]
            }
          }
        }
        schema
      end

      def amis_crud_base
        schema = {
          type: 'crud',
          id: 'crud',
          api: amis_api,
          draggable: true,
          perPage: 50,
          maxItemSelectionLength: 50,
          autoFillHeight: false,
          labelTpl: "${id} ${name}",
          autoGenerateFilter: true,
          filterTogglable: true,
          headerToolbar: ["bulkActions", "columns-toggler", "drag-toggler", "pagination"],
          footerToolbar: ['statistics', 'switch-per-page', 'pagination']
        }
        schema
      end

      def amis_operation_base
        schema = {
          type: 'operation',
          label: I18n.t('operation'),
          width: 140,
          toggled: true
        }
        schema
      end

      def amis_create_button resource = nil
        resource ||= @resource
        schema = {
          type: 'button',
          label: I18n.t('actions.create'),
          icon: 'fa fa-plus pull-left',
          primary: true,
          actionType: 'link',
          link: "/#{resource}/create"
        }
        schema
      end

      def amis_view_button resource = nil
        resource ||= @resource
        schema = {
          type: 'button',
          level: 'link',
          icon: 'fa fa-eye',
          tooltip: I18n.t('view'),
          actionType: 'link',
          link: "/#{resource}/${id}"
        }
        schema
      end

      def amis_edit_button resource = nil
        resource ||= @resource
        schema = {
          type: 'button',
          level: 'link',
          icon: 'fa fa-pencil',
          tooltip: I18n.t('edit'),
          actionType: 'link',
          link: "/#{resource}/${id}/edit"
        }
        schema
      end

      def amis_api resource = nil, id = nil, type = nil
        resource ||= @resource
        id ||= @id
        type ||= @type

        if type == 'edit'
          "put:amis/#{resource}/#{id}"
        elsif type == 'create' || type == 'list'
          "amis/#{resource}"
        end
      end

      def amis_breadcrumb items = []
        schema = {type: 'breadcrumb', items: []}
        items.each do |item|
          schema[:items] << {label: I18n.t("permissions.#{item}")}
        end

        schema[:items] << {label: I18n.t(@type)} if @type.present? && @type != 'list'
        schema[:style] = {'margin-bottom' => '12px'}
        schema
      end

      def amis_string schema = {}
        schema[:type] ||= 'input-text'
        schema
      end

      def amis_searchable filter
        schema = {
          type: 'input-text',
          name: "#{filter}_cont",
          label: filter,
          placeholder: filter
        }
        
        schema
      end
    end
  end
end






