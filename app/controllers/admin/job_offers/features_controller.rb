# frozen_string_literal: true

class Admin::JobOffers::FeaturesController < Admin::BaseController
  skip_load_and_authorize_resource

  before_action :check_authorized
  before_action :set_job_offer
  before_action :notice_not_found, unless: -> { @job_offer }, only: :create

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
