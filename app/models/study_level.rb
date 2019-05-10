# frozen_string_literal: true

# Education level asked by a job offer
class StudyLevel < ApplicationRecord
  acts_as_list
  default_scope -> { order(position: :asc) }

  validates :name, presence: true, uniqueness: true

  has_many :job_offers
end
