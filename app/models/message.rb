# frozen_string_literal: true

# Internal messaging system exchanged by recruiters around a specific job application
class Message < ApplicationRecord
  belongs_to :job_application
  belongs_to :administrator

  validates :body, presence: true

  default_scope { order(created_at: :desc) }

  audited associated_with: :job_application
end
