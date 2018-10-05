class Email < ApplicationRecord
  belongs_to :job_application
  belongs_to :sender, polymorphic: true

  validates :subject, :body, presence: true

  audited associated_with: :job_application

  attr_accessor :template

  counter_culture :job_application,
    column_name: :emails_count,
    touch: true

  after_save :compute_job_application_notifications_counter

  def compute_job_application_notifications_counter
    job_application.compute_notifications_counter!
  end
end
