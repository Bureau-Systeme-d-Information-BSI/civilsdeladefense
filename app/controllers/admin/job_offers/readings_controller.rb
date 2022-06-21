# frozen_string_literal: true

class Admin::JobOffers::ReadingsController < Admin::BaseController
  skip_load_and_authorize_resource

  def create
    @job_offer = JobOffer.friendly.find(params[:id])
    @job_offer.job_applications.map(&:mark_all_as_read!)

    redirect_back(fallback_location: [:admin, @job_offer], notice: t(".success"))
  end
end
