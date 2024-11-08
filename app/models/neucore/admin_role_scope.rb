# == Schema Information
#
# Table name: admin_role_scopes
#
#  id                     :bigint           not null, primary key
#  deleted_at             :datetime
#  name                   :string
#  scope                  :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

class Neucore::AdminRoleScope < NeucoreRecord
  self.table_name = 'admin_role_scopes'
  
  auto_strip_attributes :name, :scope
  # validates_uniqueness_of :name, :scope

  has_many :admin_roles

  def self.scopes model = ''
    if model.present?
      all.map(&:scope).compact.uniq.map(&:foreign_key).map(&:to_sym).select{|field| model.attribute_names.include?(field.to_s)}
    else
      all.map(&:scope).compact.uniq.map(&:foreign_key).map(&:to_sym)
    end
  end
end
