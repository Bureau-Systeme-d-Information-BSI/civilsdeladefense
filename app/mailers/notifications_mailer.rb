# frozen_string_literal: true

# Periodic notifications mailer
class NotificationsMailer < ApplicationMailer
  def new_email
    @administrator = params[:administrator]
    @job_application = params[:job_application]
    @job_offer = @job_application.job_offer
    @service_name = @administrator.organization.service_name

    subject = t(
      ".subject",
      service_name: @service_name,
      state: JobApplication.human_attribute_name("state/#{@job_application.state}")
    )

    mail to: @administrator.email, subject:
  end

  def contract_drafting
    @administrator = params[:administrator]
    @job_application = params[:job_application]
    @job_offer = @job_application.job_offer
    @service_name = @administrator.organization.service_name
    @employer_recruiters = @job_application.job_offer_employer_recruiters
    @hr_managers = @job_application.job_offer_hr_managers

    mail to: @administrator.email, subject: t(".subject", service_name: @service_name)
  end

  def daily_summary(administrator, data, service_name)
    @data = data
    subject = t(".subject", service_name: service_name)

    mail to: administrator.email, subject: subject
  end
end
