json.scopes do
  json.all do
    json.title I18n.t('scopes.all')
    json.count @unscoped_objects.count
  end

  @scopes&.each do |scope|
    json.set! scope do
      json.title @model ? I18n.t("scopes.#{@model}.#{scope}", default: scope.titleize) : I18n.t("scopes.#{scope}", default: scope.titleize)
      json.count @unscoped_objects.send(scope).count
    end
  end
end
