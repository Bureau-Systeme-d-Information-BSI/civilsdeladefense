# frozen_string_literal: true

class Admin::JobApplicationsController < Admin::BaseController
  # GET /admin/job_applications
  # GET /admin/job_applications.json
  def index
    @contract_types = ContractType.all
    @employers = Employer.all

    @job_applications = @job_applications.includes(:job_offer, :user, :personal_profile)
    @q = @job_applications.ransack(params[:q])
    @results = @q.result
    @results = @results.search_full_text(params[:s]) if params[:s].present?
    @results = @results.paginate(page: params[:page], per_page: 25)
  end

  # GET /admin/job_applications/1
  # GET /admin/job_applications/1.json
  def show
    user = @job_application.user
    @other_job_applications = user.job_applications.where.not(id: @job_application.id)
    render layout: request.xhr? ? false : 'admin/simple'
  end

  # PATCH/PUT /admin/job_applications/1
  # PATCH/PUT /admin/job_applications/1.json
  def update
    respond_to do |format|
      if @job_application.update(job_application_params)
        personal_profile = @job_application.user.personal_profile
        personal_profile&.datalake_to_job_application_profiles!
        format.html { redirect_to [:admin, @job_application], notice: t('.success') }
        format.js do
          @notification = t('.success')
          render :update
        end
      else
        format.html { render :edit }
        format.js do
          @notification = t('.failure')
          render :update, status: :unprocessable_entity
        end
      end
    end
  end

  def change_state
    @state = params[:state]
    known_aasm_state = @job_application.aasm.states.detect { |s| s.name.to_s == @state }
    raise ForbiddenState.new(state: @state) if known_aasm_state.nil?

    @job_application.send("#{known_aasm_state.name}!")
    @job_offer = @job_application.job_offer
    state_i18n = JobApplication.human_attribute_name("state/#{@state}")

    current_max = @job_offer.current_most_advanced_job_applications_state
    if @job_offer.most_advanced_job_applications_state_before_type_cast != current_max
      @job_offer.update_column(:most_advanced_job_applications_state, current_max)
    end

    respond_to do |format|
      format.html do
        notice = t('.success', state: state_i18n)
        redirect_back(fallback_location: [:admin, @job_application], notice: notice)
      end
      format.js do
        @notification = t('.success', state: state_i18n)
        render :change_state
      end
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
    fields = %i[skills_fit_job_offer experiences_fit_job_offer]
    profile_fields = %i[id gender birth_date nationality has_residence_permit is_currently_employed
                        availability_date_in_month study_level_id study_type specialization
                        experience_level_id corporate_experience website_url
                        has_corporate_experience
                        address_1 address_2 postcode city country phone
                        rejection_reason_id]
    fields << { user_attributes: [:id, personal_profile_attributes: profile_fields] }
    params.require(:job_application).permit(fields)
  end
end
