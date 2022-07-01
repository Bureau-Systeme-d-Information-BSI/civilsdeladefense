# frozen_string_literal: true

# Budget Operationnel de Programme
class Bop < ApplicationRecord
  acts_as_list
  default_scope -> { order(position: :asc) }

  validates :name, presence: true, uniqueness: true

  has_many :job_offers
end

# == Schema Information
#
# Table name: bops
#
#  id         :uuid             not null, primary key
#  name       :string
#  position   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_bops_on_name      (name) UNIQUE
#  index_bops_on_position  (position)
#
