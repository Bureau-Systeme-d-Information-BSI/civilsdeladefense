# Deprecated on 2024-09-11 : will be removed after version 1.5.0
class DepartmentUser < ApplicationRecord
  belongs_to :user
  belongs_to :department
end

# == Schema Information
#
# Table name: department_users
#
#  id            :uuid             not null, primary key
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  department_id :uuid             not null
#  user_id       :uuid             not null
#
# Indexes
#
#  index_department_users_on_department_id  (department_id)
#  index_department_users_on_user_id        (user_id)
#
# Foreign Keys
#
#  fk_rails_8e06d10610  (department_id => departments.id)
#  fk_rails_e05f7de22c  (user_id => users.id)
#
