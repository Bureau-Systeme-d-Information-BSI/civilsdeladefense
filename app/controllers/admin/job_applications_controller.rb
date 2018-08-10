class Admin::JobApplicationsController < Admin::BaseController
  before_action :set_job_application, only: [:show, :edit, :update, :destroy]

  # GET /admin/job_applications
  # GET /admin/job_applications.json
  def index
    @job_applications = JobApplication.all
  end

  # GET /admin/job_applications/1
  # GET /admin/job_applications/1.json
  def show
  end

  # GET /admin/job_applications/new
  def new
    @job_application = JobApplication.new
  end

  # GET /admin/job_applications/1/edit
  def edit
  end

  # POST /admin/job_applications
  # POST /admin/job_applications.json
  def create
    @job_application = JobApplication.new(job_application_params)

    respond_to do |format|
      if @job_application.save
        format.html { redirect_to [:admin, @job_application], notice: 'Job application was successfully created.' }
        format.json { render :show, status: :created, location: @job_application }
      else
        format.html { render :new }
        format.json { render json: @job_application.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/job_applications/1
  # PATCH/PUT /admin/job_applications/1.json
  def update
    respond_to do |format|
      if @job_application.update(job_application_params)
        format.html { redirect_to [:admin, @job_application], notice: 'Job application was successfully updated.' }
        format.json { render :show, status: :ok, location: @job_application }
      else
        format.html { render :edit }
        format.json { render json: @job_application.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/job_applications/1
  # DELETE /admin/job_applications/1.json
  def destroy
    @job_application.destroy
    respond_to do |format|
      format.html { redirect_to [:admin, :job_applications], notice: 'Job application was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_job_application
      @job_application = JobApplication.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def job_application_params
      params.require(:job_application).permit(:job_offer_id, :user_id, :first_name, :last_name, :current_position, :phone, :address_1, :address_2, :postal_code, :city, :country, :portfolio_url, :website_url, :linkedin_url)
    end
end
