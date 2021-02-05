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
    @email.sender = current_user
    @email.job_application = @job_application
    @notification = t('.success')

    respond_to do |format|
      if @email.save
        format.turbo_stream do
          instruction = turbo_stream.prepend('emails', partial: 'email', locals: { email: @email })
          render turbo_stream: instruction
        end
        format.html { redirect_to [:account, @job_application], notice: @notification }
      else
        format.turbo_stream do
          instruction = turbo_stream.replace(@email, partial: 'form', locals: { email: @email})
          render turbo_stream: instruction
        end
        format.html { render :new }
      end
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def email_params
    params.require(:email).permit(:subject, :body)
  end

  def set_job_application
    @job_application = current_user.job_applications.find(params[:job_application_id])
    @job_offer = @job_application.job_offer
  end
end
