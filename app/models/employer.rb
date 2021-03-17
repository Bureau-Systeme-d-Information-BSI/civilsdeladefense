# frozen_string_literal: true

# Top level organization regrouping recruiters
class Employer < ApplicationRecord
  has_many :job_offers

  validates :name, :code, presence: true, uniqueness: true

  acts_as_nested_set counter_cache: :children_count

  def name_with_code
    "#{name} (#{code})"
  end
end

# == Schema Information
#
# Table name: employers
#
#  id             :uuid             not null, primary key
#  children_count :integer          default(0), not null
#  code           :string
#  depth          :integer          default(0)
#  lft            :integer
#  name           :string
#  rgt            :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  parent_id      :uuid
#
# Indexes
#
#  index_employers_on_name  (name) UNIQUE
#
