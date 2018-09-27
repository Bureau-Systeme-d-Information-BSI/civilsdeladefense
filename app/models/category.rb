class Category < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  acts_as_nested_set

  has_many :job_offers
  has_many :publicly_visible_job_offers, -> { publicly_visible }, class_name: 'JobOffer'
end
