# frozen_string_literal: true

class Account::WithdrawalsController < Account::BaseController
  skip_load_and_authorize_resource

  def create
    @job_application = JobApplication.find(params[:job_application_id])
    if @job_application.affected? || @job_application.rejected?
      return redirect_to account_job_application_path(@job_application), notice: t(".failure")
    end

    @job_application.reject!(rejection_reason:)
    respond_to do |format|
      format.html { redirect_to account_job_application_path(@job_application), notice: t(".success") }
    end
  end

  private

  def rejection_reason = RejectionReason.find_by(name: "Désistement du/de la candidat.e")
end
