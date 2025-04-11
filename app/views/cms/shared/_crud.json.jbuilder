json.type 'wrapper'
json.style do
  json.padding '0'
end

json.body do
  json.child! do
    json.merge! @breadcrumbs
  end if @breadcrumbs

  json.child! do
    json.type 'page'
    json.id 'page_crud'
    json.initApi @initApi
    json.data do
      json.merge! @data || {}
    end
    json.toolbar do
      json.type 'flex'
      json.justify 'flex-start'
      json.style do
        json.padding '12px 12px 0 12px'
        json.gap '12px'
      end

      json.items @toolbar
    end if @toolbar

    json.body do
      json.child! do
        json.merge! amis_crud_tabs(@scopes || @data[:scope_keys])
      end if @data[:scope_keys]

      if @brief.present?
        json.child! do
          json.type 'panel'
          json.merge! @brief
        end
      end

      json.child! do
        json.merge! amis_crud_base
        json.headerToolbar @headerToolbar
        json.bulkActions @bulkActions
        json.deferApi @deferApi
        json.quickSaveItemApi @quickSaveItemApi
        json.columns @columns
        json.footerToolbar @footerToolbar || ['statistics', 'switch-per-page', 'pagination']
      end
    end
  end
end