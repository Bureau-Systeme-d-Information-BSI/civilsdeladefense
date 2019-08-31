# frozen_string_literal: true

# Budget Operationnel de Programme
class Bop < ApplicationRecord
  acts_as_list
  default_scope -> { order(position: :asc) }

  validates :name, presence: true, uniqueness: true

  has_many :job_offers
end
