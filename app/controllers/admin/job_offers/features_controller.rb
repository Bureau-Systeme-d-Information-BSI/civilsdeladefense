# frozen_string_literal: true

class Admin::JobOffers::FeaturesController < Admin::BaseController
  skip_load_and_authorize_resource

  before_action :check_authorized

  def create
    if job_offer&.update(featured: true)
      redirect_back(fallback_location: %i[admin job_offers], notice: t(".success"))
    else
      redirect_back(fallback_location: %i[admin job_offers], notice: t(".error"))
    end
  end

  def destroy
    if job_offer&.update(featured: false)
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

  def check_authorized = authorize! :feature, :job_offer
end
