# frozen_string_literal: true

class Level < ApplicationRecord
  acts_as_list
  default_scope -> { order(position: :asc) }

  validates :name, presence: true, uniqueness: true

  has_many :job_offers, dependent: :nullify
end

# == Schema Information
#
# Table name: levels
#
#  id         :uuid             not null, primary key
#  name       :string
#  position   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_levels_on_name      (name) UNIQUE
#  index_levels_on_position  (position)
#
