class Account::JobApplicationsController < Account::BaseController
  before_action :set_job_application, only: [:show]

  # GET /account/job_applications
  # GET /account/job_applications.json
  def index
    @job_applications = current_user.job_applications.includes(:job_offer)
  end

  # GET /account/job_applications/1
  # GET /account/job_applications/1.json
  def show
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_job_application
      @job_application = current_user.job_applications.find(params[:id])
      @job_offer = @job_application.job_offer
    end
end
