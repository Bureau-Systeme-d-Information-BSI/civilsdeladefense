# frozen_string_literal: true

# Container for real file mandatory to fullfill a job application
class JobApplicationFile < ApplicationRecord
  include Securable
  include Validatable

  attr_accessor :job_application_file_existing_id, :do_not_provide_immediately

  belongs_to :job_application
  belongs_to :job_application_file_type

  mount_uploader :content, DocumentUploader, mount_on: :content_file_name
  validates :content, file_size: {less_than: 2.megabytes}

  validates :content, presence: true, unless: proc { |file| file.do_not_provide_immediately }
  validates :job_application_file_type_id, uniqueness: {scope: :job_application_id} # rubocop:disable Rails/UniqueValidationWithoutIndex

  delegate :state, to: :job_application, prefix: true

  before_validation do
    if job_application_file_existing_id
      existing = JobApplicationFile.find_by(id: job_application_file_existing_id)
      self.content = existing&.content if existing&.content
    end
  end

  def record_by_user
    if save
      job_application.compute_notifications_counter!
      notify_administrators
      true
    else
      false
    end
  end

  def downloadable? = JobApplication.states[job_application_state] < max_downloadable_state

  def unrequestable? = !job_application_file_type.required?

  def unrequest!
    if unrequestable?
      destroy
    else
      errors.add(:base, :cant_unrequest)
      false
    end
  end

  private

  def max_downloadable_state
    job_application_file_type.visibility_rules.where(by: :administrator).maximum(:state)
  end

  def notify_administrators
    file_type = job_application_file_type
    admins_to_notify = []
    admins_to_notify.concat(job_application.job_offer_employer_recruiters) if file_type.notify_employer_recruiter
    admins_to_notify.concat(job_application.job_offer_employment_authorities) if file_type.notify_employment_authority
    admins_to_notify.concat(job_application.job_offer_hr_managers) if file_type.notify_hr_manager
    admins_to_notify.concat(job_application.job_offer_payroll_managers) if file_type.notify_payroll_manager
    admins_to_notify.uniq.each do |administrator|
      NotificationsMailer.with(administrator:, job_application:).new_document.deliver_later
    end
  end
end

# == Schema Information
#
# Table name: job_application_files
#
#  id                               :uuid             not null, primary key
#  content_file_name                :string
#  encrypted_file_transfer_in_error :boolean          default(FALSE)
#  is_validated                     :integer          default(0)
#  secured_content_file_name        :string
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#  job_application_file_type_id     :uuid
#  job_application_id               :uuid
#
# Indexes
#
#  index_job_application_files_on_job_application_file_type_id  (job_application_file_type_id)
#  index_job_application_files_on_job_application_id            (job_application_id)
#
# Foreign Keys
#
#  fk_rails_334ab4b230  (job_application_file_type_id => job_application_file_types.id)
#  fk_rails_d6522ee61f  (job_application_id => job_applications.id)
#
