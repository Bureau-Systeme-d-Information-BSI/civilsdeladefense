class Admin::RejectionsController < Admin::BaseController
  skip_load_and_authorize_resource

  before_action :set_job_application

  def new
    render layout: false if request.xhr?
  end

  def create
    if current_administrator.can?(:update_application_rejected, @job_application)
      @job_application.reject!(rejection_reason:)
      @notification = t(".success")
    else
      @notification = t(".unauthorized")
    end
    respond_to do |format|
      format.html { redirect_to admin_job_application_path(@job_application), notice: @notification }
      format.js
    end
  end

  def destroy
    if current_administrator.can?(:update_application_rejected, @job_application)
      @job_application.unreject!
      @notification = t(".success")
    else
      @notification = t(".unauthorized")
    end
    respond_to do |format|
      format.html { redirect_to admin_job_application_path(@job_application), notice: @notification }
      format.js
    end
  end

  private

  def set_job_application = @job_application = JobApplication.find(params[:job_application_id])

  def rejection_reason = RejectionReason.find(rejection_params[:rejection_reason_id])

  def rejection_params = params.require(:job_application).permit(:rejection_reason_id)
end
