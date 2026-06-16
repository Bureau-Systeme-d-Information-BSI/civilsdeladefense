# frozen_string_literal: true

class JobOffersController < ApplicationController
  before_action :set_job_offers, only: %i[index]
  before_action :set_job_offer, only: %i[show]
  layout "job_offer_display", only: %i[show]

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

  private

  def set_job_offers
    @job_offers = JobOffer
      .publicly_visible
      .includes(:contract_type, :category, :study_level, :experience_level, :organization, :bookmarks)
      .order(published_at: :desc)

    @job_offers = @job_offers.includes(:study_level) if request.format.json?

    @job_offers = @job_offers.where(search_params.to_h) if search_params.present?

    @job_offers = @job_offers.where(category_id: searched_category_ids) if searched_category_ids.present?

    if contract_start_on.present?
      start_of_month = contract_start_on.beginning_of_month
      end_of_month = contract_start_on.end_of_month
      @job_offers = @job_offers.where(contract_start_on: start_of_month..end_of_month)
    end

    if published_at.present?
      start_of_month = published_at.beginning_of_month
      end_of_month = published_at.end_of_month
      @job_offers = @job_offers.where(published_at: start_of_month..end_of_month)
    end

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
end
