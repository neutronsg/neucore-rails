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
    json.className 'detail-page bg-transparent'
    json.bodyClassName 'pd-0'

    json.data do
      json.id @object.id
      json.permissions default_member_permissions(@object)
      json.merge! @data || {}
    end

    json.body do
      json.child! do
        json.type 'flex'
        json.justify 'flex-end'
        json.className 'detail-action'
        json.style do
          json.padding '0 0 12px 12px'
          json.gap '12px'
        end
        json.items @toolbar
      end if @toolbar

      @panels&.each do |panel|
        json.child! do
          json.type 'panel'
          json.className 'detail-panel'
          json.merge! panel
        end      
      end

      @partials&.each do |partial|
        json.child! do
          json.partial! partial
        end
      end

      json.child! do
        json.partial! 'cms/versions/schema'
      end unless @hide_versions
    end
  end
end
