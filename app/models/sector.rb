class Sector < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_many :salary_ranges, dependent: :destroy
end
