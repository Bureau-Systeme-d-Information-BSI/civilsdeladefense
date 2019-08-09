# frozen_string_literal: true

# Reasons when rejecting a job application. Manageable by admins.
class RejectionReason < ApplicationRecord
  validates :name, presence: true
end
