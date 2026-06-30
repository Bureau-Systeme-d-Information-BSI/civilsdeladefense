# frozen_string_literal: true

class Admin::JobOffers::FeaturedController < Admin::BaseController
  skip_load_and_authorize_resource

  before_action :authorize_featured
  before_action :set_job_offers
  layout "admin/job_offer_single"

  def show
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
end
