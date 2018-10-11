class Sector < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  acts_as_list

  has_many :job_offers
  has_many :salary_ranges, dependent: :destroy
end
