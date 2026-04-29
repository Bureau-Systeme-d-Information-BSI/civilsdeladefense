# frozen_string_literal: true

class Account::WithdrawalsController < Account::BaseController
  skip_load_and_authorize_resource
  before_action :set_job_application
  before_action :redirect_to_job_application, if: :already_affected_or_rejected?

  def create
    @job_application.reject!(rejection_reason:, from_user: true)
    respond_to do |format|
      format.html { redirect_to account_job_application_path(@job_application), notice: t(".success") }
    end
  end

  private

  def rejection_reason = RejectionReason.withdrawal_reason

  def set_job_application
    @job_application = JobApplication.find(params[:job_application_id])
  end

  def already_affected_or_rejected?
    @job_application.affected? || @job_application.rejected?
  end

  def redirect_to_job_application
    redirect_to account_job_application_path(@job_application), notice: t(".failure")
  end
end
