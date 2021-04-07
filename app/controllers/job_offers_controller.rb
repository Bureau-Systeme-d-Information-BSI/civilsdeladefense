# frozen_string_literal: true

class JobOffersController < ApplicationController
  before_action :set_job_offers, only: %i[index]
  before_action :set_job_offer, only: %i[show apply send_application successful]
  invisible_captcha only: [:send_application], honeypot: :subtitle
  layout "job_offer_display", only: %i[show apply successful send_application]

  # GET /job_offers
  # GET /job_offers.json
  def index
    @page = current_organization.pages.where(parent_id: nil).first
    @categories = Category.order("lft ASC").where(
      "published_job_offers_count > ? AND depth = ?", 0, 0
    ).includes(:children)
    @contract_types = ContractType.all
    @study_levels = StudyLevel.all
    @experience_levels = ExperienceLevel.all
    @regions = JobOffer.regions

    respond_to do |format|
      format.html {}
      format.js {}
      format.json {}
    end
  end

  # GET /job_offers/1
  # GET /job_offers/1.json
  def show
  end

  # GET /job_offers/1/apply
  # GET /job_offers/1/apply.json
  def apply
    # Store location if user signup after
    store_location_for(:user, request.fullpath)

    if user_signed_in? && (@previous_job_application = current_user.job_applications.first)
      @job_application = @previous_job_application.dup
      @job_application.state = JobApplication.new.state
      @job_application.profile = @previous_job_application.profile.dup
    else
      @job_application = JobApplication.new
      @job_application.user = user_signed_in? ? current_user : User.new
      @job_application.build_profile
    end
  end

  # POST /job_offers/1/send_application
  # POST /job_offers/1/send_application.json
  def send_application
    @job_application = JobApplication.new(job_application_params)
    @job_application.job_offer = @job_offer
    @job_application.organization = @job_offer.organization
    @job_application.user = current_user if user_signed_in?
    @job_application.user.organization_id = current_organization.id if @job_application.user
    @job_application.build_profile

    respond_to do |format|
      if @job_application.save
        @job_offer.initial! if @job_offer.start?
        @job_application.send_confirmation_email
        format.html { redirect_to [:successful, @job_offer] }
        format.json do
          json = @job_application.to_json(only: %i[id])
          render json: json, status: :created, location: [:successful, @job_offer]
        end
      else
        format.turbo_stream do
          instruction = turbo_stream.replace(@job_application, partial: "/job_applications/form")
          render turbo_stream: instruction
        end
        format.html { render :show }
        format.json { render json: @job_application.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /job_offers/1/successful
  # GET /job_offers/1/successful.json
  def successful
  end

  private

  def set_job_offers
    @job_offers = JobOffer.publicly_visible.includes(:contract_type, :category).order(published_at: :desc)

    @job_offers = @job_offers.includes(:study_level) if request.format.json?

    @job_offers = @job_offers.where(search_params.to_h) if search_params.present?

    @job_offers = @job_offers.where(category_id: searched_category_ids) if searched_category_ids.present?

    @job_offers = @job_offers.where("contract_start_on <= ?", params[:contract_start_on]) if params[:contract_start_on].present?
    @job_offers = @job_offers.where("published_at <= ?", params[:published_at]) if params[:published_at].present?

    @job_offers = @job_offers.search_full_text(params[:q]) if params[:q].present?
    @job_offers = @job_offers.paginate(page: params[:page], per_page: 15) unless params[:no_pagination]
  end

  def set_job_offer
    @job_offer = JobOffer.find(params[:id])
    if !@job_offer.published? && !always_display_job_offer(@job_offer)
      raise JobOfferNotAvailableAnymore.new(job_offer_title: @job_offer.title)
    end
    return redirect_to @job_offer, status: :moved_permanently if params[:id] != @job_offer.slug
  end

  def job_application_params
    permitted_params = %i[]
    user_attributes = %i[first_name last_name current_position phone website_url]
    base_user_attributes = %i[
      photo email password password_confirmation terms_of_service certify_majority
    ]
    user_attributes += base_user_attributes unless user_signed_in?
    permitted_params << {user_attributes: user_attributes}
    job_application_files_attributes = %i[content job_application_file_type_id job_application_file_existing_id]
    permitted_params << {job_application_files_attributes: job_application_files_attributes}
    params.require(:job_application).permit(permitted_params)
  end

  def search_params
    params.permit(
      job_offers: {
        study_level_id: [], contract_type_id: [], experience_level_id: [], county: [], region: []
      }
    )[:job_offers]
  end

  def search_category_params
    params.permit(
      job_offers: {category_id: []}
    ).dig(:job_offers, :category_id)
  end

  def searched_category_ids
    return if search_category_params.blank?
    return @all_searched_category_ids if @all_searched_category_ids.present?

    selected_categories = Category.where(id: search_category_params)
    # Remove childs to be more efficient
    parent_categories = selected_categories.reject { |categ|
      (selected_categories - [categ]).any? { |cat| categ.is_descendant_of?(cat) }
    }

    # Search all category
    @all_searched_category_ids = parent_categories.map { |categ| categ.self_and_descendants.pluck(:id) }.flatten
  end

  def always_display_job_offer(job_offer)
    administrator_signed_in? || (user_signed_in? && current_user.already_applied?(job_offer))
  end
end
