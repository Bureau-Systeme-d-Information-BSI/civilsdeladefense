# frozen_string_literal: true

class JobOffersController < ApplicationController
  before_action :set_job_offers, only: %i[index]
  before_action :set_job_offer, only: %i[show apply send_application successful]
  invisible_captcha only: [:send_application], honeypot: :subtitle

  # GET /job_offers
  # GET /job_offers.json
  def index
    @page = current_organization.pages.where(parent_id: nil).first
    @categories = Category.order('lft ASC').where('published_job_offers_count > ?', 0)
    @max_depth_limit = 1
    @categories_for_select = @categories.select { |x| x.depth <= @max_depth_limit }
    @contract_types = ContractType.all

    respond_to do |format|
      format.html {}
      format.js {}
    end
  end

  # GET /job_offers/1
  # GET /job_offers/1.json
  def show
  end

  # GET /job_offers/1/apply
  # GET /job_offers/1/apply.json
  def apply
    if user_signed_in? && (@previous_job_application = current_user.job_applications.first)
      @job_application = @previous_job_application.dup
      @job_application.state = JobApplication.new.state
      if current_user.personal_profile.present?
        @job_application.personal_profile = current_user.personal_profile.dup
      else
        @job_application.build_personal_profile(country: 'FR')
      end
    else
      @job_application = JobApplication.new
      @job_application.user = User.new
      @job_application.build_personal_profile(country: 'FR')
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

    respond_to do |format|
      if @job_application.save
        @job_offer.initial! if @job_offer.start?
        @job_application.send_confirmation_email
        @job_application.personal_profile.datalake_to_user_profile!

        format.html { redirect_to %i[account job_applications] }
        format.json do
          json = @job_application.to_json(only: %i[id])
          render json: json, status: :created, location: [:successful, @job_offer]
        end
      else
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
    @job_offers = JobOffer.publicly_visible.includes(:contract_type)
    if params[:category_id].present?
      @category = Category.find(params[:category_id])
      @job_offers = @job_offers.where(category_id: @category.self_and_descendants)
    end
    if params[:contract_type_id].present?
      @contract_type = ContractType.find(params[:contract_type_id])
      if @contract_type.present?
        @job_offers = @job_offers.where(contract_type_id: @contract_type.id)
      end
    end
    @job_offers = @job_offers.search_full_text(params[:q]) if params[:q].present?
    @job_offers = @job_offers.to_a
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_job_offer
    @job_offer = JobOffer.find(params[:id])
    if !@job_offer.published? && !administrator_signed_in?
      raise JobOfferNotAvailableAnymore.new(job_offer_title: @job_offer.title)
    end
    return redirect_to @job_offer, status: :moved_permanently if params[:id] != @job_offer.slug
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def job_application_params
    permitted_params = %i[terms_of_service certify_majority]

    profile_fields = %i[id current_position phone website_url
                        address_1 address_2 postcode city country]
    permitted_params << [personal_profile_attributes: profile_fields]
    user_attributes = %i[first_name last_name]
    user_attributes += %i[photo email password password_confirmation] unless user_signed_in?
    permitted_params << { user_attributes: user_attributes }
    job_application_files_attributes = %i[content job_application_file_type_id]
    permitted_params << { job_application_files_attributes: job_application_files_attributes }
    params.require(:job_application).permit(permitted_params)
  end
end
