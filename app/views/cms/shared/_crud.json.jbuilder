columns_toggler = {
  type: 'columns-toggler',
  align: 'right',
  draggable: true,
  icon: 'fas fa-cog',
  overlay: true,
  footerToolbar: 'sm'
}

total_value_expression = '(total === undefined || total === null ? count : total)'
single_page_visible_on = '${' + total_value_expression + ' <= perPage}'
multiple_pages_visible_on = '${' + total_value_expression + ' > perPage}'

pagination = {type: 'pagination', visibleOn: multiple_pages_visible_on}
default_footer_toolbar = [
  {type: 'tpl', tpl: '${' + total_value_expression + '} total', visibleOn: single_page_visible_on},
  {type: 'statistics', visibleOn: multiple_pages_visible_on},
  {type: 'switch-per-page', visibleOn: multiple_pages_visible_on},
  pagination
]
using_default_footer_toolbar = !@footerToolbar
footer_toolbar = @footerToolbar || default_footer_toolbar

if @headerToolbar.present?
  @headerToolbar << pagination
  @headerToolbar << columns_toggler
else
  @headerToolbar = [pagination, columns_toggler]
end

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
      json.justify @flex_justify || 'flex-start'
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

      if @table.present?
        json.child! do
          json.type 'panel'
          json.merge! @table
        end
      end

      json.child! do
        json.merge! amis_crud_base
        json.rowClassNameExpr @rowClassNameExpr
        json.headerToolbar @headerToolbar
        json.bulkActions @bulkActions
        json.deferApi @deferApi
        json.quickSaveItemApi @quickSaveItemApi
        json.columns @columns
        json.alwaysShowPagination using_default_footer_toolbar
        json.footerToolbar footer_toolbar
      end
    end
  end
end
