class Admin::DarsController < Admin::BaseController
  skip_load_and_authorize_resource

  before_action :set_job_application

  def update
    @job_application.update!(job_application_params)
    flash.now[:notice] = t(".success")
  end

  private

  def set_job_application
    @job_application = JobApplication.find(params[:job_application_id])
    authorize! :validate_dar, @job_application
  end

  def job_application_params = params.require(:job_application).permit(:dar)
end
