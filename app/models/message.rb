class Message < ApplicationRecord
  belongs_to :job_application
  belongs_to :administrator

  validates :body, presence: true

  default_scope { order(created_at: :desc) }
end
