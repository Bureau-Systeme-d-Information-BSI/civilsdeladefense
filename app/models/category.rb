class Category < ApplicationRecord
  validates :name, presence: true

  has_many :job_offers
end
