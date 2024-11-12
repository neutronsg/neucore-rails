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
#  admin_role_scope_ids   :jsonb
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

  def self.load_permissions
    begin
      file = File.open("#{Rails.root}/config/neucore.yml")
      result = YAML.load(file)['permissions']
      defauts = result.delete('default')
      customs = result.delete('custom')
      ps = {}
      defauts.each do |model|
        ps[model] = %w(create read update destroy)
      end

      customs.each do |model, actions|
        if ps[model].present?
          ps[model] = ps[model] + actions
        else
          ps[model] = actions
        end
      end
      ps
    rescue
      raise 'Permissions load failed'
    end
  end

  def admin_role_scopes
    Neucore::AdminRoleScope.where(id: admin_role_scope_ids).all
  end

  def permissions_text
    permissions&.map do |model, actions|
      next unless actions.present?
      title = I18n.t("permissions.#{model}", default: model.titleize)
      actions_text = actions.collect{|action| I18n.t("permissions.#{action}", default: action.titleize)}
      "#{title}: #{actions_text.join(", ")}"
    end&.compact&.join("\n")
  end
end











