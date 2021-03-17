# frozen_string_literal: true

# Number of year of experience in the field
class ExperienceLevel < ApplicationRecord
  acts_as_list
  default_scope -> { order(position: :asc) }

  validates :name, presence: true, uniqueness: true

  has_many :job_offers
  has_many :salary_ranges, dependent: :destroy
end

# == Schema Information
#
# Table name: experience_levels
#
#  id         :uuid             not null, primary key
#  name       :string
#  position   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_experience_levels_on_name      (name) UNIQUE
#  index_experience_levels_on_position  (position)
#
