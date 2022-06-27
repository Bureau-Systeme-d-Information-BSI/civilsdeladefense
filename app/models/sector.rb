# frozen_string_literal: true

# Genreric activity sector of a job offer. Technical, health, etc.
class Sector < ApplicationRecord
  acts_as_list
  default_scope -> { order(position: :asc) }

  validates :name, presence: true, uniqueness: true

  has_many :job_offers
  has_many :salary_ranges, dependent: :destroy
end

# == Schema Information
#
# Table name: sectors
#
#  id         :uuid             not null, primary key
#  name       :string
#  position   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_sectors_on_name      (name) UNIQUE
#  index_sectors_on_position  (position)
#
