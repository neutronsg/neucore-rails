default_actions = actions.map do |action|
  case action
  when "destroy"
    {name: I18n.t("actions.#{action}"), action: action, type: "warn", confirmation: I18n.t("actions.destroy_confirmation")}
  else
    {name: I18n.t("actions.#{action}"), action: action}
  end
end

json.default_actions default_actions
