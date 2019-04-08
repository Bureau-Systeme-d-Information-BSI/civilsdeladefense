class Admin::JobApplicationsController < Admin::BaseController
  # GET /admin/job_applications
  # GET /admin/job_applications.json
  def index
    @contract_types = ContractType.all
    @employers = Employer.all

    @job_applications = @job_applications.includes(:job_offer, :user)

    %i(category_id contract_type_id).each do |filter|
      if params[filter].present? && (obj = filter.to_s.gsub('_id', '').classify.constantize.find(params[filter])).present?
        @job_applications = @job_applications.where(job_offers: {filter => obj.id})
        instance_variable_set("@#{ filter.to_s.gsub('_id', '') }", obj)
      end
    end
    %i(employer_id).each do |filter|
      if params[filter].present? && (obj = filter.to_s.gsub('_id', '').classify.constantize.find(params[filter])).present?
        @job_applications = @job_applications.where(filter => obj.id)
        instance_variable_set("@#{ filter.to_s.gsub('_id', '') }", obj)
      end
    end
    %i(state).each do |filter|
      if params[filter].present?
        @job_applications = @job_applications.where(filter => params[filter])
        instance_variable_set("@#{ filter.to_s.gsub('_id', '') }", params[filter])
      end
    end
    @job_applications = @job_applications.search_full_text(params[:q]) if params[:q].present?
    @job_applications = @job_applications.paginate(page: params[:page], per_page: 25)
  end

  # GET /admin/job_applications/1
  # GET /admin/job_applications/1.json
  def show
    @other_job_applications = @job_application.user.job_applications.where.not(id: @job_application.id)
    render layout: request.xhr? ? false : "admin/simple"
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

  def change_state
    @state = params[:state].to_s
    @job_application.send("#{ @state }!".to_sym)
    @job_offer = @job_application.job_offer
    state_i18n = JobApplication.human_attribute_name("state/#{ @state }")

    val = @job_offer.job_applications.where(job_offer_id: @job_offer.id).select(:state, :created_at).group(:state, :created_at).map{|x| x.state_before_type_cast}.max
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
      params.require(:job_application).permit(:job_offer_id, :user_id, :first_name, :last_name, :current_position, :phone, :address_1, :address_2, :postal_code, :city, :country, :website_url)
    end
end
