# frozen_string_literal: true

# Email exchanged between a candidate and a group of recruiters around a job application
class Email < ApplicationRecord
  attr_accessor :attachments

  belongs_to :job_application
  belongs_to :sender, optional: true, polymorphic: true

  has_many :email_attachments, dependent: :destroy

  validates :subject, :body, presence: true

  audited associated_with: :job_application

  attr_accessor :template

  counter_culture :job_application, column_name: :emails_count, touch: true

  before_validation :fill_attachments
  after_save :compute_job_application_notifications_counter

  def send_from_user
    return false unless save
    notify_employer_recruiters if job_application.phone_meeting? || job_application.to_be_met?
    true
  end

  def compute_job_application_notifications_counter
    job_application.compute_notifications_counter!
  end

  def automatic_email?
    sender.nil?
  end

  def fill_attachments
    return if attachments.blank?

    attachments.compact_blank.map { |a| email_attachments.build(content: a) }
  end

  def mark_as_read!
    update!(is_unread: false)
  end

  def mark_as_unread!
    update!(is_unread: true)
  end

  private

  def notify_employer_recruiters
    job_application.job_offer_employer_recruiters.each do |administrator|
      notify_employer_recruiter(administrator)
    end
  end

  def notify_employer_recruiter(administrator)
    NotificationsMailer.with(administrator:, job_application:).new_email.deliver_later
  end
end

# == Schema Information
#
# Table name: emails
#
#  id                 :uuid             not null, primary key
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
