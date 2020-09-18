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
  has_many :personal_profiles
end
