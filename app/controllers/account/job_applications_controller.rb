class Account::JobApplicationsController < Account::BaseController
  before_action :set_job_application, except: %i(index finished)
  before_action :set_job_applications, only: %i(index finished)

  # GET /account/job_applications
  # GET /account/job_applications.json
  def index
    @job_applications = @job_applications_active
  end

  # GET /account/job_applications/finished
  # GET /account/job_applications/finished.json
  def finished
    @job_applications = @job_applications_finished

    render action: :index
  end

  # GET /account/job_applications/1
  # GET /account/job_applications/1.json
  def show
    @emails = @job_application.emails.order(created_at: :desc)
    @email = @job_application.emails.new

    render layout: request.xhr? ? false : true
  end

  private

    def set_job_applications
      @job_applications_active = job_applications_root.not_finished
      @job_applications_finished = job_applications_root.finished
    end

    def job_applications_root
      current_user.job_applications.includes(job_offer: [:contract_type]).order(created_at: :desc)
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_job_application
      @job_application = current_user.job_applications.find(params[:job_application_id] || params[:id])
      @job_offer = @job_application.job_offer
    end
end
