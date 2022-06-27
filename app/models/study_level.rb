# frozen_string_literal: true

# Education level asked by a job offer
class StudyLevel < ApplicationRecord
  acts_as_list
  default_scope -> { order(position: :asc) }

  validates :name, presence: true, uniqueness: true

  has_many :job_offers
end

# == Schema Information
#
# Table name: study_levels
#
#  id             :uuid             not null, primary key
#  name           :string
#  official_level :integer
#  position       :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_study_levels_on_name      (name) UNIQUE
#  index_study_levels_on_position  (position)
#
