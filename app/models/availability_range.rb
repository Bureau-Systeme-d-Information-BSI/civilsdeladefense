# frozen_string_literal: true

# Dans combien de temps le/la candidat/candidate est disponible
class AvailabilityRange < ApplicationRecord
  acts_as_list
  default_scope -> { order(position: :asc) }

  has_many :profiles, dependent: :nullify

  validates :name, presence: true, uniqueness: true
  validate :check_employed, if: -> { employed? }, on: :update

  before_destroy -> { throw :abort }, if: -> { employed? }, prepend: true

  def self.employed = find_by(name: "En poste")

  def employed? = self == self.class.employed

  private

  def check_employed = errors.add(:base, "En poste ne peut pas être modifié")
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
