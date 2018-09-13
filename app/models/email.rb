class Email < ApplicationRecord
  belongs_to :job_application
  belongs_to :sender, polymorphic: true

  validates :subject, :body, presence: true

  audited associated_with: :job_application
end
