json.extract! version, :id, :created_at
json.created_at version.created_at 
json.changeset format_version_changeset(resource, version)
operator = nil
if version.whodunnit.to_s.start_with?("0")
  operator = "#{I18n.t('activerecord.models.admin_user')} #{version.whodunnit[1..-1]}"
elsif version.whodunnit.to_s.start_with?("1")
  operator ||= "#{I18n.t('activerecord.models.user')} #{version.whodunnit[1..-1].to_i}"
else
  operator = I18n.t('system')
end
json.operator operator
