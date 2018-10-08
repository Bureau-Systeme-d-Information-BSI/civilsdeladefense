class ProfessionalCategory < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end
