# frozen_string_literal: true

class Admin::Emails::ReadingsController < Admin::BaseController
  skip_load_and_authorize_resource
  load_and_authorize_resource :job_application
  load_and_authorize_resource :email, through: :job_application

  def create
    @email.mark_as_read!
    @job_application.reload

    respond_to do |format|
      format.html { redirect_back(fallback_location: [:admin, @job_application], notice: t(".success")) }
      format.js do
        @notification = t(".success")
        render "admin/emails/email_operation"
      end
      format.json { render json: @email.to_json, status: :ok, location: [:admin, @job_application] }
    end
  end

  def destroy
    @email.mark_as_unread!
    @job_application.reload

    respond_to do |format|
      format.html { redirect_back(fallback_location: [:admin, @job_application], notice: t(".success")) }
      format.js do
        @notification = t(".success")
        render "admin/emails/email_operation"
      end
      format.json { render json: @email.to_json, status: :ok, location: [:admin, @job_application] }
    end
  end
end
