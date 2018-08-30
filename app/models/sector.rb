class Sector < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end
