json.type 'wrapper'
json.style do
  json.padding '0'
end

json.body do
  json.child! do
    json.merge! amis_breadcrumb(['settings', 'admin_user'])
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
            json.merge! amis_string_column(label: AdminUser.human_attribute_name(:name), name: 'name')
          end

          json.child! do
            json.merge! amis_string_column(label: AdminUser.human_attribute_name(:email), name: 'email')
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

              json.child! do
                json.type 'button'
                json.level 'link'
                json.label '重置密码'
                json.actionType 'dialog'
                json.dialog do
                  json.title '重置密码'
                  json.body do
                    json.type 'form'
                    json.body do
                      json.child! do
                        json.type 'static'
                        json.name 'engine'
                        json.label 'Engine'
                      end

                      json.child! do
                        json.type 'divider'
                      end

                      json.child! do
                        json.type 'static'
                        json.name 'browser'
                        json.label 'Browser'
                      end

                      json.child! do
                        json.type 'divider'
                      end

                      json.child! do
                        json.type 'static'
                        json.name 'platform'
                        json.label 'Platform(s)'
                      end

                      json.child! do
                        json.type 'divider'
                      end

                      json.child! do
                        json.type 'static'
                        json.name 'version'
                        json.label 'Engine version(s)'
                      end

                      json.child! do
                        json.type 'divider'
                      end

                      json.child! do
                        json.type 'static'
                        json.name 'grade'
                        json.label 'CSS grade'
                      end

                      json.child! do
                        json.type 'divider'
                      end

                      json.child! do
                        json.type 'html'
                        json.html "<p>添加其他 <span>Html 片段</span> 需要支持变量替换（todo）.</p>"
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
