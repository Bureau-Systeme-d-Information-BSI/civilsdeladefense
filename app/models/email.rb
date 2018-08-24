class Email < ApplicationRecord
  belongs_to :job_application
  belongs_to :administrator

  validates :title, :body, presence: true
end
