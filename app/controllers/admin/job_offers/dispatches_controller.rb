# frozen_string_literal: true

class Admin::JobOffers::DispatchesController < Admin::BaseController
  skip_load_and_authorize_resource
  before_action :set_job_offer
  before_action :authorize_dispatch
  layout "admin/job_offer_single"

  def new
  end

  def create
    preferred_users_lists = PreferredUsersList.where(id: params[:preferred_users_lists])
    preferred_users_lists.each do |list|
      @job_offer.send_to_users(list.users)
    end

    redirect_to %i[admin job_offers], notice: t(".success")
  end

  private

  def set_job_offer
    @job_offer = JobOffer.find(params[:job_offer_id])
  end

  def authorize_dispatch
    authorize! :manage, @job_offer
  end
end
