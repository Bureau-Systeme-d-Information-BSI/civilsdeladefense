class ExperienceLevel < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end
