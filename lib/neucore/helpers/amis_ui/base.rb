module Neucore
  module Helpers
    module AmisUi
      module Base
        def amis_operation_base options = {}
          schema = {
            type: 'operation',
            label: options[:label] || I18n.t('operation'),
            width: options[:width] || 140,
            toggled: true,
            fixed: 'right'
          }

          schema
        end

        def amis_breadcrumb items = []
          schema = {type: 'breadcrumb', items: []}
          items.each do |item|
            schema[:items] << {label: I18n.t("permissions.#{item}")}
          end
          schema[:items].last[:href] = "/#{items.last.tableize}"

          if @type == 'view'
            schema[:items] << {label: @object.id.to_s}
          end

          if @type == 'custom'
            schema[:items] << {label: I18n.t(@id)}
          else
            schema[:items] << {label: I18n.t(@type)} if @type.present? && @type != 'list'
          end
          schema[:style] = {'margin-bottom' => '12px'}

          schema
        end

        def amis_form_base options = {}
          schema = options
          schema[:type] ||= 'form'
          schema[:static] ||= @type == 'view'
          schema[:api] = amis_api
          schema[:title] ||= I18n.t("forms.basic_information")
          schema[:mode] ||= 'horizontal'
          schema[:actions] ||= []
          # schema[:debug] = true
          
          schema
        end

        def amis_crud_base
          schema = {
            type: 'crud',
            id: 'crud',
            api: amis_api,
            draggable: false,
            syncLocation: true,
            perPage: 50,
            maxItemSelectionLength: 50,
            autoFillHeight: false,
            labelTpl: "${id} ${name}",
            autoGenerateFilter: {
              columnsNum: 4,
              showBtnToolbar: false
            },
            filterTogglable: true,
            # columnsTogglable: false,
            headerToolbar: ["bulkActions", "pagination"],
            footerToolbar: ['statistics', 'switch-per-page', 'pagination']
          }
          
          schema
        end

        def amis_api resource = nil, id = nil, type = nil
          resource ||= @resource
          id ||= @id
          type ||= @type

          if type == 'edit'
            "put:cms/#{resource}/#{id}"
          elsif type == 'create' || type == 'list'
            "cms/#{resource}"
          end
        end

        def amis_qrcode options = {}
          schema = options
          schema[:codeSize] ||= 128
          schema[:type] = 'qr-code'

          schema
        end
      end
    end
  end
end
