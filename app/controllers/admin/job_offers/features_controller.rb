# frozen_string_literal: true

class Admin::JobOffers::FeaturesController < Admin::BaseController
  skip_load_and_authorize_resource

  layout "admin/job_offer_single"

  before_action :authorize_featured, only: :index
  before_action :set_job_offers, only: :index
  before_action :check_authorized, only: %i[create destroy]
  before_action :set_job_offer, only: %i[create destroy]
  before_action :notice_not_found, unless: -> { @job_offer }, only: :create

  def index
  end

  def create
    if @job_offer.update(featured: true)
      redirect_back_or_to(%i[admin job_offers], notice: t(".success"))
    else
      redirect_back_or_to(
        %i[admin job_offers], notice: t(".error", message: @job_offer.errors.full_messages.to_sentence)
      )
    end
  end

  def destroy
    if @job_offer.update(featured: false)
      redirect_back_or_to(%i[admin job_offers], notice: t(".success"))
    else
      redirect_back_or_to(
        %i[admin job_offers], notice: t(".error", message: @job_offer.errors.full_messages.to_sentence)
      )
    end
  end

  private

  def authorize_featured = authorize!(:featured, JobOffer)

  def set_job_offers
    @job_offers = JobOffer.accessible_by(current_ability, :featured)
    @job_offers_unfiltered = @job_offers.admin_index_featured
    job_offers_nearly_filtered = @job_offers_unfiltered
    if params[:s].present?
      job_offers_nearly_filtered = job_offers_nearly_filtered
        .search_full_text(params[:s])
        .unscope(:order)
    end
    @q = job_offers_nearly_filtered.ransack(params[:q])
    @job_offers_filtered = @q.result(distinct: true).page(params[:page]).per_page(20)
  end

  def set_job_offer
    @job_offer = if params[:job_offer_identifier].present?
      JobOffer.find_by(identifier: params[:job_offer_identifier])
    else
      JobOffer.find(params[:job_offer_id])
    end
  end

  def notice_not_found = redirect_back_or_to(%i[admin job_offers], notice: t(".not_found"))

  def check_authorized = authorize! :feature, :job_offer
end
