class Admin::JobOffersController < Admin::BaseController
  before_action :set_job_offer, only: [:show, :edit, :update, :destroy].push(*JobOffer.aasm.events.map(&:name)).push(*JobOffer.aasm.events.map{ |x| "update_and_#{x.name}".to_sym })

  # GET /job_offers
  # GET /job_offers.json
  def index
    @categories = Category.order(name: :asc).includes(:job_offers).all

    render layout: 'admin/simple'
  end

  # GET /job_offers/1
  # GET /job_offers/1.json
  def show
    @job_applications = @job_offer.job_applications.group_by(&:state)
  end

  # GET /job_offers/new
  def new
    @job_offer = JobOffer.new
  end

  # GET /job_offers/1/edit
  def edit
  end

  # POST /job_offers
  # POST /job_offers.json
  def create
    @job_offer = JobOffer.new(job_offer_params)
    @job_offer.owner = current_administrator

    respond_to do |format|
      if @job_offer.save
        format.html { redirect_to [:admin, :job_offers], notice: t('.success') }
        format.json { render :show, status: :created, location: @job_offer }
      else
        format.html { render :new }
        format.json { render json: @job_offer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /job_offers/1
  # PATCH/PUT /job_offers/1.json
  def update
    respond_to do |format|
      if @job_offer.update(job_offer_params)
        format.html { redirect_to [:admin, :job_offers], notice: t('.success') }
        format.json { render :show, status: :ok, location: @job_offer }
      else
        format.html { render :edit }
        format.json { render json: @job_offer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /job_offers/1
  # DELETE /job_offers/1.json
  def destroy
    @job_offer.destroy
    respond_to do |format|
      format.html { redirect_to job_offers_url, notice: t('.success') }
      format.json { head :no_content }
    end
  end

  JobOffer.aasm.events.map(&:name).each do |event_name|

    define_method(event_name) do
      @job_offer.send("#{event_name}!")
      respond_to do |format|
        format.html { redirect_back(fallback_location: job_offers_url, notice: t('.success')) }
        format.js {
          @notification = t('.success')
          render :state_change
        }
        format.json { render :show, status: :ok, location: @job_offer }
      end
    end

    define_method("update_and_#{ event_name }".to_sym) do

      respond_to do |format|
        if @job_offer.update(job_offer_params) and @job_offer.send("#{event_name}!")
          format.html { redirect_to [:admin, :job_offers], notice: t('.success') }
          format.json { render :show, status: :ok, location: @job_offer }
        else
          format.html { render :edit }
          format.json { render json: @job_offer.errors, status: :unprocessable_entity }
        end
      end

    end

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_job_offer
      @job_offer = JobOffer.find(params[:id])
      if params[:id] != @job_offer.slug
        return redirect_to [:admin, @job_offer], status: :moved_permanently
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def job_offer_params
      params.require(:job_offer).permit(permitted_fields)
    end

    def permitted_fields
      fields = [:title, :description, :category_id, :official_status_id, :location, :employer_id, :required_profile, :recruitment_process, :contract_type_id, :contract_start_on, :is_remote_possible, :study_level_id, :experience_level_id, :sector_id, :is_negotiable, :estimate_monthly_salary_net, :estimate_monthly_salary_gross]
      other_fields = (JobOffer::FILES + JobOffer::URLS).map{ |x| "option_#{x}".to_sym }
      fields.push(*other_fields)
    end
end
