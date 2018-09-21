class Account::JobApplicationsController < Account::BaseController
  before_action :set_job_application, only: [:show, :update]
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

  def update
    @file_name = job_application_params.keys.first

    respond_to do |format|
      if @job_application.update(job_application_params)
        @job_application.update_column "#{@file_name}_is_validated", 0
        format.html { redirect_to [:account, @job_application], notice: t('.success') }
        format.js {}
        format.json { render :show, status: :ok, location: [:account, @job_application] }
      else
        format.html { render :edit }
        format.js {}
        format.json { render json: @job_application.errors, status: :unprocessable_entity }
      end
    end
  end

  private

    def set_job_applications
      @job_applications_active = job_applications_root.not_finished
      @job_applications_finished = job_applications_root.finished
    end

    def job_applications_root
      current_user.job_applications.includes(job_offer: [:contract_type])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_job_application
      @job_application = current_user.job_applications.find(params[:id])
      @job_offer = @job_application.job_offer
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def job_application_params
      params.require(:job_application).permit(:resume, :cover_letter)
    end
end
