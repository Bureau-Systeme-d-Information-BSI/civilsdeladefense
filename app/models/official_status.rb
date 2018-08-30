class OfficialStatus < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end
