# frozen_string_literal: true

class Admin::JobOffers::FeaturesController < Admin::BaseController
  skip_load_and_authorize_resource

  def create
    authorize! :feature, :job_offer

    if job_offer&.update(featured: true)
      redirect_back(fallback_location: %i[admin job_offers], notice: t(".success"))
    else
      redirect_back(fallback_location: %i[admin job_offers], notice: t(".error"))
    end
  end

  private

  def job_offer
    if params[:job_offer_identifier].present?
      JobOffer.find_by(identifier: params[:job_offer_identifier])
    else
      JobOffer.find(params[:job_offer_id])
    end
  end
end
