# == Schema Information
#
# Table name: admin_roles
#
#  id                     :bigint           not null, primary key
#  deleted_at             :datetime
#  owner_id               :bigint
#  owner_type             :string
#  name                   :string
#  permissions            :jsonb
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

class Neucore::AdminRole < NeucoreRecord
  self.table_name = 'admin_roles'
  
  auto_strip_attributes :name
  validates_uniqueness_of :name, scope: :owner

  has_many :admin_user_roles
  has_many :admin_users, through: :admin_user_roles
  belongs_to :owner, polymorphic: true, required: false
  belongs_to :admin_role_scope, required: false

  def self.load_permissions
    begin
      file = File.open("#{Rails.root}/config/neucore.yml")
      YAML.load(file)['permissions']
    rescue
      raise 'Permissions load failed'
    end
  end

  def permissions_text
    permissions.map do |model, actions|
      next unless actions.present?
      title = I18n.t("permissions.#{model}", default: model.titleize)
      actions_text = actions.collect{|action| I18n.t("permissions.#{action}", default: action.titleize)}
      "#{title}: #{actions_text.join(", ")}"
    end.compact.join("\n")
  end
end











