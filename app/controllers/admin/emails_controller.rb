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

        format.html { redirect_to [:admin, @email.job_application], notice: t('.success') }
        format.js do
          @email = Email.new
          @email.job_application = @job_application
          @notification = t('.success')
          render :create
        end
        format.json { render :show, status: :created, location: @email }
      else
        format.html { render :new }
        format.js do
          @notification = t('.unsuccess')
          render :create
        end
        format.json { render json: @email.errors, status: :unprocessable_entity }
      end
    end
  end

  def mark_as_read
    @email.is_unread = false
    @email.save
    @job_application.reload

    respond_to do |format|
      format.html do
        location = [:admin, @job_application, @email]
        redirect_back(fallback_location: location, notice: t('.success'))
      end
      format.js do
        @notification = t('.success')
        render :email_operation
      end
      format.json do
        location = [:admin, @job_application, @email]
        render json: @email.to_json, status: :ok, location: location
      end
    end
  end

  def mark_as_unread
    @email.is_unread = true
    @email.save
    @job_application.reload

    respond_to do |format|
      format.html do
        location = [:admin, @job_application, @email]
        redirect_back(fallback_location: location, notice: t('.success'))
      end
      format.js do
        @notification = t('.success')
        render :email_operation
      end
      format.json do
        location = [:admin, @job_application, @email]
        render json: @email.to_json, status: :ok, location: location
      end
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def email_params
    params.require(:email).permit(:subject, :body, attachments: [])
  end
end
