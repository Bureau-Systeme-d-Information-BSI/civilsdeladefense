# frozen_string_literal: true

# Reasons when rejecting a job application. Manageable by admins.
class RejectionReason < ApplicationRecord
  acts_as_list
  default_scope -> { order(position: :asc) }

  validates :name, presence: true
end
