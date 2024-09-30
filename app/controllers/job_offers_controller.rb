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

  def show
    respond_to do |format|
      format.html {}
      format.pdf { render_job_offer_as_pdf }
    end
  end

  # GET /job_offers/1/apply
  # GET /job_offers/1/apply.json
  def old_apply
    redirect_to apply_job_offers_path(id: params[:id]), status: :moved_permanently
  end

  # GET /job_offers/apply?id=1
  # GET /job_offers/apply.json?id=1
  def apply
    # Store location if user signup after
    store_location_for(:user, request.fullpath)
    if user_signed_in? && (previous_job_application = current_user.job_applications.first)
      @job_application = previous_job_application.dup
      @job_application.state = JobApplication.new.state
    else
      @job_application = JobApplication.new
      @job_application.user = user_signed_in? ? current_user : User.new
    end
    @job_application.user.build_profile if @job_application.user.profile.nil?
  end

  # POST /job_offers/1/send_application
  # POST /job_offers/1/send_application.json
  def send_application
    @job_application = JobApplication.new(job_application_params)
    @job_application.job_offer = @job_offer
    @job_application.organization = @job_offer.organization
    @job_application.user = current_user if user_signed_in?
    @job_application.user.organization = current_organization unless user_signed_in?

    if user_signed_in?
      if job_application_params[:user_attributes].present?
        @job_application.user.assign_attributes(
          job_application_params[:user_attributes].except(:department_users_attributes, :profile_attributes)
        )
      end
      @job_application.user.departments = departments
      @job_application.user.profile.assign_attributes(job_application_params[:user_attributes][:profile_attributes])

      @job_application.job_application_files.select do |job_application_file|
        job_application_file.job_application_file_existing_id == current_user.profile&.resume&.id
      end.each do |resume|
        @job_application.job_application_files = @job_application.job_application_files - [resume]
        jaf = JobApplicationFile.new(
          job_application: @job_application,
          job_application_file_type_id: resume.job_application_file_type_id
        )
        if Rails.env.development?
          jaf.content = current_user.profile.resume.content.file.path
        else
          jaf.remote_content_url = current_user.profile.resume.content_url
        end
        @job_application.job_application_files << jaf
      end
    end

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
        format.html { render :apply }
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
    @job_offers = JobOffer
      .publicly_visible
      .includes(:contract_type, :category, :study_level, :experience_level, :organization, :bookmarks)
      .order(published_at: :desc)

    @job_offers = @job_offers.includes(:study_level) if request.format.json?

    @job_offers = @job_offers.where(search_params.to_h) if search_params.present?

    @job_offers = @job_offers.where(category_id: searched_category_ids) if searched_category_ids.present?

    @job_offers = @job_offers.where("contract_start_on <= ?", contract_start_on) if contract_start_on.present?
    @job_offers = @job_offers.where("published_at >= ?", published_at) if published_at.present?

    @job_offers = @job_offers.bookmarked(current_user) if params[:bookmarked].present? && user_signed_in?

    @job_offers = @job_offers.search_full_text(params[:q]) if params[:q].present?
    @job_offers = @job_offers.paginate(page: page, per_page: 15) unless params[:no_pagination]
  end

  def set_job_offer
    if params[:id].blank?
      return redirect_to job_offers_url
    end

    @job_offer = JobOffer.find(params[:id])
    if !@job_offer.published? && !always_display_job_offer(@job_offer)
      raise JobOfferNotAvailableAnymore.new(job_offer_title: @job_offer.title)
    end
    redirect_to @job_offer, status: :moved_permanently if params[:id] != @job_offer.slug
  end

  def job_application_params
    params.require(:job_application).permit(
      :category_id,
      user_attributes: [
        :first_name,
        :last_name,
        :phone,
        :website_url,
        :photo,
        :email,
        :password,
        :password_confirmation,
        :terms_of_service,
        :certify_majority,
        :receive_job_offer_mails,
        profile_attributes: [
          :gender,
          :has_corporate_experience,
          :age_range_id,
          :availability_range_id,
          :experience_level_id,
          :study_level_id,
          profile_foreign_languages_attributes: [
            :foreign_language_id,
            :foreign_language_level_id
          ]
        ],
        department_users_attributes: [
          :department_id
        ]
      ],
      job_application_files_attributes: [
        :content,
        :job_application_file_type_id,
        :job_application_file_existing_id
      ]
    )
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

  def contract_start_on
    @contract_start_on ||= parse_date(:contract_start_on)
  end

  def published_at
    @published_at ||= parse_date(:published_at)
  end

  def parse_date(param_name)
    return nil if params[param_name].blank?

    Date.parse(params[param_name])
  rescue ArgumentError
    nil
  end

  def page
    @page ||= parse_page
  end

  def parse_page
    Integer(params[:page])
  rescue ArgumentError, TypeError
    1
  end

  def render_job_offer_as_pdf
    send_data pdf_job_offer.render, filename: pdf_job_offer.filename, type: "application/pdf", disposition: "inline"
  end

  def pdf_job_offer = @pdf_job_offer ||= PdfJobOffer.new(@job_offer)

  def departments = Department.where(id: department_ids)

  def department_ids = department_user_attributes&.to_unsafe_h&.map { |_, department| department[:department_id] }

  def department_user_attributes = job_application_params.dig(:user_attributes, :department_users_attributes)
end
