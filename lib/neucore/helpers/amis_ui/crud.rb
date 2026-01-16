module Neucore
  module Helpers
    module AmisUi
      # CRUD helper module for generating Baidu Amis framework CRUD components
      # Provides convenient Ruby methods to generate JSON schema for various Amis CRUD features
      # including tabs, columns, actions, and data display components
      #
      # Each method returns a hash that can be converted to JSON for use in Amis CRUD tables
      # All methods accept an options hash to customize the component behavior
      module Crud
        # Generates tabs for CRUD scope filtering
        # Creates tabbed interface for filtering data by different scopes with dynamic counts
        #
        # @param scopes [Array] Array of scope names for creating tabs
        # @return [Hash] Amis tabs schema with scope filtering functionality
        def amis_crud_tabs(scopes)
          tabs = []
          scopes.each do |scope|
            tabs << {
              title: {
                type: "tpl",
                # tpl: "${scopes.#{scope}.title}(${scopes.#{scope}.count})"
                tpl: "${scopes.#{scope}.title}${scopes.#{scope}.count == undefined ? '' : '(' + ${scopes.#{scope}.count} + ')'}"
              }
            }
          end

          {
            type: "tabs",
            tabsMode: "line",
            tabs: tabs,
            className: "crudTabs",
            visibleOn: "${scopes}",
            activeKey: "${INT(scope)}",
            onEvent: {
              change: {
                actions: [
                  {
                    componentId: "crud",
                    actionType: "reload",
                    data: {
                      scope: "${scope_keys[event.data.value - 1]}"
                    }
                  }
                ]
              }
            }
          }
        end

        # Generates an ID column for CRUD tables
        # Creates a standard ID column with left-fixed positioning
        #
        # @param options [Hash] Configuration options for the ID column
        # @option options [String] :name Field name (default: 'id')
        # @option options [String] :label Column label (default: 'ID')
        # @option options [String] :fixed Column position (default: 'left')
        # @return [Hash] Amis column schema for ID display
        def amis_id_column(options = {})
          {
            name: "id",
            label: "ID",
            fixed: "left"
          }.merge(options)
        end

        # Generates a status column with status indicator styling
        # Creates a column that displays status values with appropriate visual indicators
        #
        # @param options [Hash] Configuration options for the status column
        # @option options [String] :name Field name for the status value
        # @option options [String] :label Column label
        # @return [Hash] Amis status column schema
        def amis_status_column(options = {})
          schema = options
          schema[:type] = "status"
          schema[:value] = "${#{options[:name]}}"

          schema
        end

        def amis_checkbox_column(options = {})
          schema = options
          schema[:type] = "checkbox"
          schema[:value] = "${#{options[:name]}}"

          schema
        end

        # Generates a mapping column for displaying mapped values
        # Creates a column that maps data values to display labels using Amis mapping
        #
        # @param options [Hash] Configuration options for the mapping column
        # @option options [String] :name Field name
        # @option options [String] :label Column label
        # @option options [Hash] :map Mapping configuration for value transformation
        # @return [Hash] Amis mapping column schema
        def amis_mapping_column(options = {})
          schema = options
          schema[:type] = "mapping"

          schema
        end

        # Generates multiple string columns for multilingual content
        # Creates separate columns for each configured locale for multilingual string display
        #
        # @param options [Hash] Configuration options for the multilingual columns
        # @option options [String] :property Base property name
        # @option options [Class] :model ActiveRecord model class for generating localized labels
        # @return [Array<Hash>] Array of Amis string column schemas, one for each locale
        def amis_string_ml_columns(options = {})
          schemas = []

          property = options.delete(:property)
          model = options.delete(:model)

          I18n.ml_locales.each do |locale|
            schemas << amis_string_column(options).merge(
              label: model.human_attribute_name("#{property}_#{locale}"),
              name: "#{property}_#{locale}"
            )
          end

          schemas
        end

        # Generates a string column with optional truncation and popover
        # Creates a text display column with configurable length limits and hover details
        #
        # @param options [Hash] Configuration options for the string column
        # @option options [String] :name Field name
        # @option options [String] :label Column label
        # @option options [Integer] :maxLength Maximum display length before truncation
        # @option options [Boolean] :popOver Show full content on hover (when truncated)
        # @return [Hash] Amis string/template column schema
        def amis_string_column(options = {})
          popOver = options.delete(:popOver)
          schema = options
          schema[:className] ||='line-clamp-3'
          if options[:maxLength]
            schema[:type] = "tpl"
            schema[:className] = "line-clamp-1"
            schema[:tpl] = "${ #{options[:name]}|truncate:#{options[:maxLength]} }"
          end

          if popOver
            schema[:popOver] = {
              trigger: "hover",
              position: "left-top",
              showIcon: false,
              visibleOn: "${ #{options[:name]}.length > #{options[:maxLength]} }",
              body: {
                type: "tpl",
                tpl: "${ #{options[:name]} }"
              }
            }
          end

          schema
        end

        # Generates a rating display column
        # Creates a star rating display column with customizable appearance
        #
        # @param options [Hash] Configuration options for the rating column
        # @option options [String] :name Field name
        # @option options [String] :label Column label
        # @option options [Integer] :count Number of stars (default: 5)
        # @option options [String] :colors Active star color (default: "#ffa900")
        # @option options [String] :inactiveColor Inactive star color (default: "#aaa")
        # @return [Hash] Amis input-rating column schema (read-only)
        def amis_rating_column(options = {})
          schema = options
          schema[:count] ||= 5
          schema[:type] = "input-rating"
          schema[:half] = true
          schema[:readOnly] = true
          schema[:colors] = "#ffa900"
          schema[:inactiveColor] = "#aaa"
          schema[:className] = "crud-rating"
          schema
        end

        # Generates a datetime display column
        # Creates a formatted datetime column with fallback for null values
        #
        # @param options [Hash] Configuration options for the datetime column
        # @option options [String] :name Field name (will be removed from final schema)
        # @option options [String] :label Column label
        # @option options [Integer] :width Column width (default: 150)
        # @return [Hash] Amis template column schema for datetime formatting
        def amis_datetime_column(options = {})
          schema = options
          schema[:width] ||= 200

          schema
        end

        def amis_date_column(options = {})
          schema = options
          schema[:width] ||= 125

          schema
        end

        # Generates an HTML content display column
        # Creates a column that renders raw HTML content safely
        #
        # @param options [Hash] Configuration options for the HTML column
        # @option options [String] :name Field name (will be removed from final schema)
        # @option options [String] :label Column label
        # @return [Hash] Amis HTML column schema
        def amis_html_column(options = {})
          name = options.delete(:name)
          schema = options
          schema[:className] ||= 'line-clamp-3'
          schema[:type] = "html"
          schema[:html] = "${raw(#{name})}"

          schema
        end

        # Generates an avatar display column
        # Creates a circular avatar image column for user profile pictures
        #
        # @param options [Hash] Configuration options for the avatar column
        # @option options [String] :name Field name containing the avatar image URL
        # @option options [String] :label Column label
        # @return [Hash] Amis avatar column schema
        def amis_avatar_column(options = {})
          schema = options.slice(:name, :label)
          schema[:type] = "avatar"
          schema[:src] = "${#{options[:name]}}"

          schema
        end

        # Generates a single image display column
        # Creates an image preview column with placeholder for missing images
        #
        # @param options [Hash] Configuration options for the image column
        # @option options [String] :name Field name containing the image URL
        # @option options [String] :label Column label
        # @return [Hash] Amis image column schema
        def amis_image_column(options = {})
          schema = options.slice(:name, :label)
          schema[:type] = "image"
          schema[:placeholder] = "-"
          schema
        end

        # Generates a video player column
        # Creates a video player column for displaying video content
        #
        # @param options [Hash] Configuration options for the video column
        # @option options [String] :name Field name containing the video URL
        # @option options [String] :label Column label
        # @return [Hash] Amis video column schema
        def amis_video_column(options = {})
          schema = options.slice(:name, :label)
          schema[:type] = "video"
          schema[:body] = {
            src: "${#{options[:name]}}"
          }

          schema
        end

        # Generates a multiple images display column
        # Creates an image gallery column for displaying multiple images
        #
        # @param options [Hash] Configuration options for the images column
        # @option options [String] :name Field name containing the images array
        # @option options [String] :label Column label
        # @return [Hash] Amis images column schema
        def amis_images_column(options = {})
          schema = options.slice(:name, :label)
          schema[:type] = "images"
          schema[:defaultImage] = ""

          schema
        end

        # Generates a clickable link column
        # Creates a button column that links to related resources with dynamic URLs
        #
        # @param options [Hash] Configuration options for the clickable column
        # @option options [String] :name Field name containing link data {label:, resource:, id:}
        # @option options [String] :label Column label
        # @option options [Boolean] :searchable Whether column is searchable
        # @return [Hash] Amis button column schema with link action
        def amis_clickable_column(options = {})
          schema = options.slice(:name, :label, :searchable)
          schema[:type] = "button"
          schema[:body] = {
            type: "button",
            level: "link",
            actionType: "link",
            label: "${raw(#{options[:name]}.label)}",
            link: "/${#{options[:name]}.resource}/${#{options[:name]}.id}"
          }
          schema[:body][:className] = options[:className] if options[:className].present?

          schema
        end

        # Generates a download link column
        # Creates a button column that triggers file downloads via API endpoints
        #
        # @param options [Hash] Configuration options for the download column
        # @option options [String] :name Field name containing the filename/label
        # @option options [String] :label Column label
        # @option options [String] :resource Resource name for API endpoint (uses @resource if not provided)
        # @option options [String] :action API action name for download endpoint
        # @option options [Boolean] :searchable Whether column is searchable
        # @return [Hash] Amis button column schema with download action
        def amis_download_column(options = {})
          resource = options.delete(:resource) || @resource
          schema = options.slice(:name, :label, :searchable)
          schema[:type] = "button"
          schema[:body] = {
            type: "button",
            level: "link",
            actionType: "download",
            label: "${#{options[:name]}}",
            api: "get:cms/#{resource}/${id}/#{options[:action]}"
          }

          schema
        end

        # Generates a multiple clickable links column
        # Creates a column that displays multiple clickable links from an array
        #
        # @param options [Hash] Configuration options for the clickables column
        # @option options [String] :name Field name containing array of link objects
        # @option options [String] :label Column label
        # @option options [String] :placeholder Text shown when no items (default: '-')
        # @option options [Boolean] :searchable Whether column is searchable
        # @return [Hash] Amis each column schema for multiple links
        def amis_clickables_column(options = {})
          {
            name: options[:name],
            type: "each",
            label: options[:label],
            placeholder: options[:placeholder] || "-",
            items: {
              type: "button",
              actionType: "link",
              level: "link",
              label: "${raw(item.label)}",
              link: "/${item.resource}/${item.id}"
            },
            searchable: options[:searchable]
          }
        end

        # Generates an interactive switch column
        # Creates a toggle switch that triggers API calls when changed
        #
        # @param options [Hash] Configuration options for the switch column
        # @option options [String] :name Field name
        # @option options [String] :label Column label
        # @option options [String] :resource Resource name for API endpoint (uses @resource if not provided)
        # @option options [String] :action API action name (default: field name or 'switch')
        # @option options [String] :method HTTP method (default: 'post')
        # @option options [String] :api Custom API endpoint (auto-generated if not provided)
        # @return [Hash] Amis switch column schema with AJAX action
        def amis_switch_column(options = {})
          resource = options.delete(:resource) || @resource
          action = options.delete(:action) || options[:name] || "switch"
          method = options.delete(:method) || "post"
          api = options.delete(:api) || "#{method}:#{Neucore.configuration.cms_path}/#{resource}/${id}/#{action}"

          schema = options
          schema[:type] = "switch"
          schema[:mode] = "horizontal"
          schema[:disabledOn] ||= "${scope == 'only_deleted' || !ARRAYINCLUDES(permissions, 'update')}"
          schema[:onEvent] = {
            change: {
              actions: [
                {
                  actionType: "ajax",
                  api: api
                }
              ]
            }
          }

          schema
        end

        # Generates a single tag display column
        # Creates a colored tag/badge column for displaying status or category
        #
        # @param options [Hash] Configuration options for the tag column
        # @option options [String] :name Field name
        # @option options [String] :label Column label (default: 'Tag')
        # @option options [String] :color Tag color (default: 'processing')
        # @option options [String] :placeholder Text shown when no value (default: '-')
        # @return [Hash] Amis tag column schema
        def amis_tag_column(options = {})
          {
            name: options[:name],
            type: "tag",
            label: options[:label] || "Tag",
            color: options[:color] || "processing",
            placeholder: options[:placeholder] || "-"
          }
        end

        # Generates a multiple tags display column
        # Creates a column that displays multiple tags from an array
        #
        # @param options [Hash] Configuration options for the tags column
        # @option options [String] :name Field name containing tags array (default: 'tags')
        # @option options [String] :label Column label (default: 'Tags')
        # @option options [String] :placeholder Text shown when no tags (default: '-')
        # @return [Hash] Amis each column schema for multiple tags
        def amis_tags_column(options = {})
          {
            name: options[:name] || "tags",
            type: "each",
            label: options[:label] || "Tags",
            placeholder: options[:placeholder] || "-",
            items: {
              type: "tag",
              color: "${item.color || 'processing'}",
              label: "${item.name || item.tag || item}"
            }
          }
        end

        # Generates a bulk action button for CRUD operations
        # Creates an action button that operates on selected rows via AJAX
        #
        # @param options [Hash] Configuration options for the bulk action
        # @option options [String] :label Button label
        # @option options [String] :resource Resource name for API endpoint (uses @resource if not provided)
        # @option options [String] :method HTTP method (default: 'post')
        # @option options [String] :url API endpoint URL
        # @option options [String] :redirect Redirect URL after action (default: "/#{resource}")
        # @return [Hash] Amis button schema with bulk AJAX action
        def amis_bulk_action(options = {})
          resource = options.delete(:resource) || @resource
          api = {
            method: options.delete(:method) || "post",
            url: options.delete(:url),
            data: { ids: "${split(ids)}" }
          }
          schema = options
          schema[:type] ||= "button"
          schema[:actionType] ||= "ajax"
          schema[:api] = api
          schema[:redirect] ||= "/#{resource}"

          schema
        end

        # Generates a CSV export action button
        # Creates an export button that downloads table data as CSV file
        #
        # @param options [Hash] Configuration options for the CSV export
        # @option options [String] :label Button label (default: localized 'Export CSV')
        # @option options [String] :align Button alignment (default: 'right')
        # @option options [String] :filename Export filename (default: current timestamp)
        # @return [Hash] Amis export-csv schema
        def amis_export_csv(options = {})
          schema = options
          schema[:type] = "export-csv"
          schema[:label] ||= I18n.t("actions.export_csv")
          schema[:align] ||= "right"
          schema[:filename] ||= "#{Time.now.to_i}"

          schema
        end

        # Generates an Excel export action button
        # Creates an export button that downloads table data as Excel file
        #
        # @param options [Hash] Configuration options for the Excel export
        # @option options [String] :label Button label (default: localized 'Export Excel')
        # @option options [String] :align Button alignment (default: 'right')
        # @option options [String] :filename Export filename (default: current timestamp)
        # @return [Hash] Amis export-excel schema
        def amis_export_excel(options = {})
          schema = options
          schema[:type] = "export-excel"
          schema[:label] ||= I18n.t("actions.export_excel")
          schema[:align] ||= "right"
          schema[:filename] ||= "#{Time.now.to_i}"

          schema
        end

        # Generates an Excel template export action button
        # Creates an export button that downloads a template Excel file for data import
        #
        # @param options [Hash] Configuration options for the Excel template export
        # @option options [String] :label Button label (default: localized 'Export Excel Template')
        # @option options [String] :align Button alignment (default: 'right')
        # @option options [String] :filename Export filename (default: current timestamp)
        # @return [Hash] Amis export-excel-template schema
        def amis_export_excel_template(options = {})
          schema = options
          schema[:type] = "export-excel-template"
          schema[:label] ||= I18n.t("actions.export_excel_template")
          schema[:align] ||= "right"
          schema[:filename] ||= "#{Time.now.to_i}"

          schema
        end
      end
    end
  end
end
