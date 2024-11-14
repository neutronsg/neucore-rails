json.type 'wrapper'
json.style do
  json.padding '0'
end

json.body do
  json.child! do
    json.merge! amis_breadcrumb(['settings', 'admin_role'])
  end

  json.child! do
    json.type 'page'
    json.toolbar do
      json.type 'container'
      json.style do
        json.padding '12px 12px 0 12px'
      end

      json.body amis_create_button
    end
    json.body do
      json.child! do
        json.merge! amis_crud_base

        json.columns do
          json.child! do
            json.merge! amis_id_column
          end

          json.child! do
            json.merge! amis_string_column(AdminRole, :name)
          end

          json.child! do
            json.merge! amis_operation_base
            json.buttons do
              json.child! do
                json.merge! amis_view_button
              end

              json.child! do
                json.merge! amis_edit_button
              end
            end
          end
        end
      end
    end
  end
end
