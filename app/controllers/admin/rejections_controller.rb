class Admin::RejectionsController < Admin::BaseController
  skip_load_and_authorize_resource

  def create
    @job_application = JobApplication.find(params[:job_application_id])
    @job_application.reject!(rejection_reason:)
    redirect_to admin_job_application_path(@job_application), notice: t(".success")
  end

  private

  def rejection_reason = RejectionReason.find(rejection_params[:rejection_reason_id])

  def rejection_params = params.require(:job_application).permit(:rejection_reason_id)
end
