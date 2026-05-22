# frozen_string_literal: true

class Admin::EmailsController < Admin::BaseController
  load_and_authorize_resource :job_application
  load_and_authorize_resource :email, through: :job_application

  # POST /admin/emails
  # POST /admin/emails.json
  def create
    @email.sender = current_administrator
    @email.job_application = @job_application

    respond_to do |format|
      if @email.save
        ApplicantNotificationsMailer.new_email(@email.id).deliver_now

        format.html { redirect_to [:admin, @email.job_application], notice: t(".success") }
        format.js do
          @email = Email.new
          @email.job_application = @job_application
          @notification = t(".success")
          render :create
        end
        format.json { render :show, status: :created, location: @email }
      else
        format.html { render @job_application }
        format.js do
          @notification = t(".unsuccess")
          render :create
        end
        format.json { render json: @email.errors, status: :unprocessable_entity }
      end
    end
  end

  def attachment
    content = @email.email_attachments.find(params[:email_attachment_id]).document_content
    send_data(
      content.read,
      filename: content.filename,
      type: content.content_type
    )
  end

  private

  def email_params
    params.require(:email).permit(:subject, :body, attachments: [])
  end
end
