module JobApplication::Notifiable
  extend ActiveSupport::Concern
  included do
    after_update :notify_applicant_new_state, if: -> { new_state_requires_applicant_notification? }
    after_update :notify_hr_managers_contract_drafting, if: -> { saved_change_to_state? && contract_drafting? }
    after_update :notify_hr_managers_contract_feedback_waiting, if: -> { saved_change_to_state? && contract_feedback_waiting? }
    after_update :notify_payroll_managers_contract_received, if: -> { saved_change_to_state? && contract_received? }
    after_update :notify_managers_affected, if: -> { saved_change_to_state? && affected? }
  end

  private

  def notify_applicant_new_state
    ApplicantNotificationsMailer.with(user:, job_offer:, state:).notify_new_state.deliver_later
  end

  def new_state_requires_applicant_notification?
    saved_change_to_state? && JobApplication::NOTIFICATION_STATES.include?(state.to_s)
  end

  def notify_hr_managers_contract_drafting
    job_offer_hr_managers.each do |administrator|
      notify_admin_new_state(administrator, :contract_drafting)
    end
  end

  def notify_hr_managers_contract_feedback_waiting
    job_offer_hr_managers.each do |administrator|
      notify_admin_new_state(administrator, :contract_feedback_waiting)
    end
  end

  def notify_payroll_managers_contract_received
    job_offer_payroll_managers.each do |administrator|
      notify_admin_new_state(administrator, :contract_received)
    end
  end

  def notify_managers_affected
    (job_offer_hr_managers + job_offer_payroll_managers).each do |administrator|
      notify_admin_new_state(administrator, :affected)
    end
  end

  def notify_admin_new_state(administrator, state)
    NotificationsMailer.with(administrator:, job_application: self).send(state).deliver_later
  end
end
