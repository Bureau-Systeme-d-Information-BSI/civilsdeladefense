class Category < ApplicationRecord
  validates :name, presence: true

  has_many :job_offers
  has_many :publicly_visible_job_offers, -> { publicly_visible }, class_name: 'JobOffer'
end
