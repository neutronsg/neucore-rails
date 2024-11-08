# == Schema Information
#
# Table name: admin_user_roles
#
#  id                     :bigint           not null, primary key
#  deleted_at             :datetime
#  admin_user_id          :bigint
#  admin_role_id          :bigint
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
class Neucore::AdminUserRole < NeucoreRecord
  self.table_name = 'admin_user_roles'
  
  belongs_to :admin_user
  belongs_to :admin_role
end
