# frozen_string_literal: true

class Account::EmailsController < Account::BaseController
  before_action :set_job_application

  # GET /account/emails
  # GET /account/emails.json
  def index
    @emails = @job_application.emails.order(created_at: :desc)
    @email = @job_application.emails.new
  end

  # POST /account/emails
  # POST /account/emails.json
  def create
    @email = @job_application.emails.build(email_params)

    respond_to do |format|
      if @email.save
        format.turbo_stream do
          s = turbo_stream.prepend("emails") {
            view_context.render partial: "email", locals: {email: @email}
          }
          new_email = @job_application.emails.new
          s += turbo_stream.replace(new_email) {
            view_context.render partial: "form", locals: {email: new_email}
          }
          render turbo_stream: s
        end
        format.html { redirect_to [:account, @job_application], notice: t(".success") }
      else
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(@email,
            partial: "form",
            locals: {email: @email})
        end
        format.html { render template: "/account/job_applications/show" }
      end
    end
  end

  def attachment
    job_application = current_user.job_applications.find(params[:job_application_id])
    email = job_application.emails.find(params[:id])
    content = email.email_attachments.find(params[:email_attachment_id]).content

    send_data(
      content.read,
      filename: content.filename,
      type: content.content_type
    )
  end

  private

  def email_params
    params.require(:email).permit(:subject, :body, attachments: []).tap do |whitelisted|
      whitelisted[:sender] = current_user
      whitelisted[:job_application] = @job_application
    end
  end

  def set_job_application
    @job_application = current_user.job_applications.find(params[:job_application_id])
    @job_offer = @job_application.job_offer
  end
end
