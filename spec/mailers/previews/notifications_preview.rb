# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/notifications
class NotificationsPreview < ActionMailer::Preview
  def new_email
    job_application = JobApplication.find_by(state: :phone_meeting) || JobApplication.first
    administrator = Administrator.employer_recruiters.first || Administrator.first
    NotificationsMailer.with(administrator:, job_application:).new_email
  end

  def contract_drafting
    job_application = JobApplication.find_by(state: :contract_drafting) || JobApplication.first
    administrator = Administrator.hr_managers.first || Administrator.first
    NotificationsMailer.with(administrator:, job_application:).contract_drafting
  end

  def contract_feedback_waiting
    job_application = JobApplication.find_by(state: :contract_feedback_waiting) || JobApplication.first
    administrator = Administrator.hr_managers.first || Administrator.first
    NotificationsMailer.with(administrator:, job_application:).contract_feedback_waiting
  end

  def contract_received
    job_application = JobApplication.find_by(state: :contract_received) || JobApplication.first
    administrator = Administrator.payroll_managers.first || Administrator.first
    NotificationsMailer.with(administrator:, job_application:).contract_received
  end

  def affected
    job_application = JobApplication.find_by(state: :affected) || JobApplication.first
    administrator = Administrator.payroll_managers.first || Administrator.hr_managers.first || Administrator.first
    NotificationsMailer.with(administrator:, job_application:).affected
  end

  def new_document
    job_application = JobApplication.first
    administrator = Administrator.hr_managers.first || Administrator.first
    NotificationsMailer.with(administrator:, job_application:).new_document
  end

  def deletion_warning
    administrator = Administrator.first
    NotificationsMailer.with(administrator:).deletion_warning
  end

  def deletion_canceled
    administrator = Administrator.first
    NotificationsMailer.with(administrator:).deletion_canceled
  end

  def deletion_notice
    administrator = Administrator.first
    NotificationsMailer.with(
      email: administrator.email,
      full_name: administrator.full_name,
      organization_id: administrator.organization_id
    ).deletion_notice
  end
end
