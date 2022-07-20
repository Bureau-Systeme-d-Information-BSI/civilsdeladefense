# frozen_string_literal: true

# Tranche d'age
class AgeRange < ApplicationRecord
  acts_as_list
  default_scope -> { order(position: :asc) }

  #####################################
  # Validations

  validates :name, presence: true

  #####################################
  # Relations
  has_many :profiles, dependent: :nullify
end

# == Schema Information
#
# Table name: age_ranges
#
#  id         :uuid             not null, primary key
#  name       :string
#  position   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_age_ranges_on_name      (name)
#  index_age_ranges_on_position  (position)
#
