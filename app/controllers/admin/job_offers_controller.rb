class Admin::JobOffersController < Admin::BaseController
  before_action :set_job_offers, only: %i(index)

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
    @job_offer = params[:job_offer_id].present? ? JobOffer.find(params[:job_offer_id]) : JobOffer.new
    @existing_administrator = Administrator.find_by(email: params[:email])
    @administrator = if @existing_administrator
      @job_offer.job_offer_actors.build(role: params[:role]).administrator = @existing_administrator
    else
      @job_offer.job_offer_actors.build(role: params[:role]).build_administrator(email: params[:email])
    end
    @administrator.inviter ||= current_administrator

    if @administrator.valid?
      render action: 'add_actor', layout: false
    else
      render json: @administrator.errors, status: :unprocessable_entity
    end
  end

  # GET /admin/job_offers/new
  def new
    @job_offer_origin = nil
    if params[:job_offer_id].present?
      @job_offer_origin = JobOffer.find params[:job_offer_id]
    end
    @job_offer = if @job_offer_origin.nil?
      j = JobOffer.new
      j.contract_start_on = 6.months.from_now
      j.option_cover_letter = :optional
      j.option_resume = :optional
      j.option_photo = :optional
      j.option_website_url = :optional
      j.recruitment_process = t('.default_recruitment_process')
      %i(employer grand_employer supervisor_employer brh).each do |actor_role|
        # j.job_offer_actors.build(role: actor_role).build_administrator
      end
      j.job_offer_actors.build(role: :employer).administrator = current_administrator
      if current_administrator.grand_employer_administrator.present?
        j.job_offer_actors.build(role: :grand_employer).administrator = current_administrator.grand_employer_administrator
      end
      if current_administrator.supervisor_administrator.present?
        j.job_offer_actors.build(role: :supervisor_employer).administrator = current_administrator.supervisor_administrator
      end
      j
    else
      j = @job_offer_origin.dup
      j.title = "Copie de #{j.title}"
      j.state = nil
      j
    end
    @job_offer.employer = current_administrator.employer unless current_administrator.bant?
  end

  # GET /admin/job_offers/1/edit
  def edit
  end

  def create_and_publish
    @job_offer = JobOffer.new(job_offer_params)
    @job_offer.owner = current_administrator
    unless current_administrator.bant?
      @job_offer.employer = current_administrator.employer
    end
    @job_offer.job_offer_actors.each{|job_offer_actor|
      if job_offer_actor.administrator
        job_offer_actor.administrator.inviter ||= current_administrator
      end
    }
    @job_offer.publish
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

  # POST /admin/job_offers
  # POST /admin/job_offers.json
  def create
    @job_offer.owner = current_administrator
    unless current_administrator.bant?
      @job_offer.employer = current_administrator.employer
    end
    @job_offer.job_offer_actors.each{|job_offer_actor|
      if job_offer_actor.administrator
        job_offer_actor.administrator.inviter ||= current_administrator
      end
    }

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

  # PATCH/PUT /admin/job_offers/1
  # PATCH/PUT /admin/job_offers/1.json
  def update
    @job_offer.assign_attributes(job_offer_params)
    @job_offer.job_offer_actors.each{|job_offer_actor|
      if job_offer_actor.administrator
        job_offer_actor.administrator.inviter ||= current_administrator
      end
    }

    respond_to do |format|
      if @job_offer.save
        format.html { redirect_to [:admin, :job_offers], notice: t('.success') }
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

      @job_offer.assign_attributes(job_offer_params)
      @job_offer.job_offer_actors.each{|job_offer_actor|
        if job_offer_actor.administrator
          job_offer_actor.administrator.inviter ||= current_administrator
        end
      }

      respond_to do |format|
        if @job_offer.save and @job_offer.send("#{event_name}!")
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

    def set_job_offers
      @employers = Employer.all

      @job_offers_active = job_offers_root.where.not(state: :archived)
      @job_offers_active = @job_offers_active.search_full_text(params[:q]) if params[:q].present?
      @job_offers_active = @job_offers_active.to_a.group_by(&:employer_id)

      @job_offers_archived = job_offers_root.archived
      @job_offers_archived = @job_offers_archived.search_full_text(params[:q]) if params[:q].present?
      @job_offers_archived = @job_offers_archived.to_a.group_by(&:employer_id)
    end

    def job_offers_root
      r = @job_offers.includes(:employer, :contract_type).order(created_at: :desc)
      # if current_administrator.grand_employer?
      #   employer_ids = current_administrator.employer.children.map(&:id) << current_administrator.employer_id
      #   r = r.where(employer_id: employer_ids)
      # elsif !current_administrator.bant?
      #   r = r.where(employer_id: current_administrator.employer_id)
      # end
      r
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_job_offer
      if params[:id] != @job_offer.slug
        return redirect_to [:admin, @job_offer], status: :moved_permanently
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def job_offer_params
      params.require(:job_offer).permit(permitted_fields)
    end

    def permitted_fields
      fields =  [:title, :description, :category_id, :professional_category_id, :employer_id, :required_profile, :recruitment_process, :contract_type_id, :duration_contract, :contract_start_on, :is_remote_possible, :available_immediately, :study_level_id, :experience_level_id, :sector_id, :estimate_monthly_salary_net, :estimate_annual_salary_gross]
      fields += [:location, :county, :county_code, :country_code, :postcode, :region]
      other_fields = (JobOffer::FILES + JobOffer::URLS).map{ |x| "option_#{x}".to_sym }
      fields  << {job_offer_actors_attributes: [:id, :role, :_destroy, administrator_attributes: [:id, :email, :_destroy]]}
      fields.push(*other_fields)
    end
end
