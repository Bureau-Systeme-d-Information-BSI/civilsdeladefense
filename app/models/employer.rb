class Employer < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end
