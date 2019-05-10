# frozen_string_literal: true

class Admin::JobOffersController < Admin::BaseController
  before_action :set_job_offers, only: %i[index]

  include JobOfferStateActions

  # GET /admin/job_offers
  # GET /admin/job_offers.json
  def index
    @archived_page = request.path =~ /archived/
    @job_offers = @archived_page ? @job_offers_archived : @job_offers_active

    render layout: 'admin/simple'
  end

  # GET /admin/job_offers/1
  # GET /admin/job_offers/1.json
  def show
    @job_applications = @job_offer.job_applications.group_by(&:state)
  end

  def add_actor
    job_offer_id = params[:job_offer_id]
    @job_offer = job_offer_id.present? ? JobOffer.find(job_offer_id) : JobOffer.new
    @administrator = find_attach_or_build_administrator
    if @administrator.valid?
      render action: 'add_actor', layout: false
    else
      render json: @administrator.errors, status: :unprocessable_entity
    end
  end

  # GET /admin/job_offers/new
  def new
    source = nil
    source = JobOffer.find(params[:job_offer_id]) if params[:job_offer_id].present?
    @job_offer = JobOffer.new_from_source(source) if source.present?
    @job_offer ||= JobOffer.new_from_scratch(current_administrator)
    @job_offer.employer = current_administrator.employer unless current_administrator.bant?
  end

  # GET /admin/job_offers/1/edit
  def edit
  end

  # POST /admin/job_offers
  # POST /admin/job_offers.json
  def create
    @job_offer.owner = current_administrator
    @job_offer.employer = current_administrator.employer unless current_administrator.bant?
    @job_offer.cleanup_actor_administrator_inviter(current_administrator)

    respond_to do |format|
      if @job_offer.save
        format.html { redirect_to %i[admin job_offers], notice: t('.success') }
        format.json { render :show, status: :created, location: @job_offer }
      else
        format.html { render :new }
        format.json { render json: @job_offer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/job_offers/1
  # PATCH/PUT /admin/job_offers/1.json
  def update
    @job_offer.assign_attributes(job_offer_params)
    @job_offer.cleanup_actor_administrator_inviter(current_administrator)

    respond_to do |format|
      if @job_offer.save
        format.html { redirect_to %i[admin job_offers], notice: t('.success') }
        format.json { render :show, status: :ok, location: @job_offer }
      else
        format.html { render :edit }
        format.json { render json: @job_offer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/job_offers/1
  # DELETE /admin/job_offers/1.json
  def destroy
    @job_offer.destroy
    respond_to do |format|
      format.html { redirect_to job_offers_url, notice: t('.success') }
      format.json { head :no_content }
    end
  end

  private

  def set_job_offers
    @employers = Employer.all
    @job_offers_active = job_offers_by_state('active')
    @job_offers_archived = job_offers_by_state('archived')
  end

  def job_offers_by_state(state)
    relation = @job_offers.send("admin_index_#{state}")
    relation = relation.search_full_text(params[:q]) if params[:q].present?
    relation.to_a.group_by(&:employer_id)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_job_offer
    redirect_to [:admin, @job_offer], status: :moved_permanently if params[:id] != @job_offer.slug
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def job_offer_params
    params.require(:job_offer).permit(permitted_fields)
  end

  def permitted_fields
    fields = %i[title description category_id professional_category_id employer_id required_profile
                recruitment_process contract_type_id duration_contract contract_start_on
                is_remote_possible available_immediately study_level_id experience_level_id
                sector_id estimate_monthly_salary_net estimate_annual_salary_gross
                location county county_code country_code postcode region]
    job_offer_actors_attributes = %i[id role _destroy]
    job_offer_actors_attributes << { administrator_attributes: %i[id email _destroy] }
    fields << { job_offer_actors_attributes: job_offer_actors_attributes }
  end

  def find_attach_or_build_administrator
    existing_administrator = Administrator.find_by(email: params[:email])
    root_object = @job_offer.job_offer_actors.build(role: params[:role])
    admin = root_object.administrator = existing_administrator if existing_administrator
    admin ||= root_object.build_administrator(email: params[:email])
    admin.inviter ||= current_administrator
    admin
  end
end
