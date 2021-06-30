# frozen_string_literal: true

# Email exchanged between a candidate and a group of recruiters around a job application
class Email < ApplicationRecord
  belongs_to :job_application
  belongs_to :sender, optional: true, polymorphic: true

  mount_uploaders :attachments, AttachmentUploader

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

  def automatic_email?
    sender.nil?
  end
end

# == Schema Information
#
# Table name: emails
#
#  id                 :uuid             not null, primary key
#  attachments        :json
#  body               :text
#  is_unread          :boolean          default(TRUE)
#  sender_type        :string
#  subject            :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  job_application_id :uuid
#  sender_id          :uuid
#
# Indexes
#
#  index_emails_on_job_application_id         (job_application_id)
#  index_emails_on_sender_type_and_sender_id  (sender_type,sender_id)
#
# Foreign Keys
#
#  fk_rails_ebb3716bca  (job_application_id => job_applications.id)
#
