class Department < ApplicationRecord
  has_many :department_users
  has_many :users, through: :department_users

  def label
    "#{code} #{name} - #{name_region}"
  end

  def self.regions
    Department.all.group_by(&:name_region)
  end
end

# == Schema Information
#
# Table name: departments
#
#  id          :uuid             not null, primary key
#  code        :string
#  code_region :string
#  name        :string
#  name_region :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
