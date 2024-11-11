# == Schema Information
#
# Table name: admin_users
#
#  id                     :bigint           not null, primary key
#  avatar                 :string
#  deleted_at             :datetime
#  email                  :string
#  super_admin            :boolean
#  encrypted_password     :string
#  name                   :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
class Neucore::AdminUser < NeucoreRecord
  self.table_name = 'admin_users'
  
  include Neucore::JwtTokenIssuer
  auto_strip_attributes :name, :email
  validates_uniqueness_of :email

  has_many :admin_user_roles
  has_many :admin_roles, through: :admin_user_roles
  belongs_to :owner, polymorphic: true, required: false

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  delegate :can?, :cannot?, to: :ability

  def ability
    @ability ||= Ability.new(self)
  end

  def permissions
    result = Set.new
    admin_roles.each do |admin_role|
    # AdminRole.where(id: [1,3]).all.each do |admin_role|
      scopes = admin_role.admin_role_scopes.map(&:scope).presence || ['ALL']
      admin_role.permissions.each do |model, actions|
        next unless actions.present?
        actions.each do |action|
          next if result.include?("#{model}:#{action}:ALL")
          scopes.each do |scope|
            result << "#{model}:#{action}:#{scope}"
          end
        end
      end
    end
    result.to_a
  end
end





