json.scopes do 
  unless defined?(without_all)
    json.child! do
      json.name I18n.t("scopes.all", default: 'All')
      json.value "all"
      json.count @unscoped_objects.count
    end
  end

  if defined?(scopes)
    model = defined?(model) ? model : nil
    scopes.each do |scope|
      json.child! do
        json.name model ? I18n.t("scopes.#{model}.#{scope}", default: scope.titleize) : I18n.t("scopes.#{scope}", default: scope.titleize)
        json.value scope
        json.count @unscoped_objects.send(scope).count
      end
    end
  end

  if defined?(with_deleted)
    json.child! do
      json.name I18n.t('scopes.only_deleted', default: 'Deleted')
      json.value "only_deleted"
      json.count @unscoped_objects.only_deleted.count
    end
  end
end
