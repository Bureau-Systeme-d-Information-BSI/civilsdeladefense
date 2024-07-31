# frozen_string_literal: true

# Dans combien de temps le/la candidat/candidate est disponible
class AvailabilityRange < ApplicationRecord
  acts_as_list
  default_scope -> { order(position: :asc) }

  validates :name, presence: true, uniqueness: true

  has_many :profiles, dependent: :nullify

  def self.en_poste
    find_by(name: "En poste")
  end
end

# == Schema Information
#
# Table name: availability_ranges
#
#  id         :uuid             not null, primary key
#  name       :string
#  position   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_availability_ranges_on_name      (name) UNIQUE
#  index_availability_ranges_on_position  (position)
#
