# frozen_string_literal: true

# Socio-Professional category of a job offer
class ProfessionalCategory < ApplicationRecord
  acts_as_list
  default_scope -> { order(position: :asc) }

  validates :name, presence: true, uniqueness: true

  has_many :job_offers
  has_many :salary_ranges, dependent: :destroy
end

# == Schema Information
#
# Table name: professional_categories
#
#  id         :uuid             not null, primary key
#  name       :string
#  position   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_professional_categories_on_name      (name) UNIQUE
#  index_professional_categories_on_position  (position)
#
