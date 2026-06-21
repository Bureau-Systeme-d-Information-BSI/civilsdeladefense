# frozen_string_literal: true

class Account::Emails::AttachmentsController < Account::BaseController
  before_action :set_job_application

  def show
    email = @job_application.emails.find(params[:email_id])
    content = email.email_attachments.find(params[:id]).document_content

    send_data(
      content.read,
      filename: content.filename,
      type: content.content_type
    )
  end

  private

  def set_job_application
    @job_application = current_user.job_applications.find(params[:job_application_id])
  end
end
