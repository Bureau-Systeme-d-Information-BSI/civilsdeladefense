# frozen_string_literal: true

# Dans combien de temps le/la candidat/candidate est disponible
class AvailabilityRange < ApplicationRecord
  acts_as_list
  default_scope -> { order(position: :asc) }

  #####################################
  # Validations

  validates :name, presence: true

  #####################################
  # Relations
  has_many :personal_profiles
end
