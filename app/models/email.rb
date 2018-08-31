class Email < ApplicationRecord
  belongs_to :job_application
  belongs_to :administrator

  validates :title, :body, presence: true

  audited associated_with: :job_application
end
