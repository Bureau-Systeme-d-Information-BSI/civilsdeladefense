class Admin::RejectionsController < Admin::BaseController
  skip_load_and_authorize_resource

  def new
    @job_application = JobApplication.find(params[:job_application_id])
    render layout: false if request.xhr?
  end

  def create
    @job_application = JobApplication.find(params[:job_application_id])
    @job_application.reject!(rejection_reason:)
    respond_to do |format|
      format.html { redirect_to admin_job_application_path(@job_application), notice: t(".success") }
      format.js
    end
  end

  private

  def rejection_reason = RejectionReason.find(rejection_params[:rejection_reason_id])

  def rejection_params = params.require(:job_application).permit(:rejection_reason_id)
end
