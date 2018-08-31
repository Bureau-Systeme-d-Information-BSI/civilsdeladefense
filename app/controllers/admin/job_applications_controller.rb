class Admin::JobApplicationsController < Admin::BaseController
  before_action :set_job_application, only: [:show, :edit, :update, :destroy, :change_state]

  # GET /admin/job_applications
  # GET /admin/job_applications.json
  def index
    @job_applications = JobApplication.all
  end

  # GET /admin/job_applications/1
  # GET /admin/job_applications/1.json
  def show
    @message = Message.new
    @message.job_application = @job_application

    @email = Email.new
    @email.job_application = @job_application

    render layout: request.xhr? ? false : "admin/simple"
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

  def change_state
    @state = params[:state].to_s
    @job_application.send("#{ @state }!".to_sym)
    @job_offer = @job_application.job_offer
    state_i18n = JobApplication.human_attribute_name("state/#{ @state }")

    val = @job_offer.job_applications.where(job_offer_id: @job_offer.id).select(:state).group(:state).map{|x| x.state_before_type_cast}.max
    if @job_offer.most_advanced_job_applications_state_before_type_cast != val
      @job_offer.update_column(:most_advanced_job_applications_state, val)
    end

    respond_to do |format|
      format.html { redirect_back(fallback_location: [:admin, @job_application], notice: t('.success', state: state_i18n)) }
      format.js {
        @notification = t('.success', state: state_i18n)
        render :change_state
      }
      format.json { render :show, status: :ok, location: @job_application }
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
