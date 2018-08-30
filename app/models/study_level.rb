class StudyLevel < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end
