# frozen_string_literal: true

class Admin::PreferredUsersLists::JobOfferSendingsController < Admin::BaseController
  skip_load_and_authorize_resource
  before_action :set_preferred_users_list
  before_action :authorize_job_offer_sending

  def create
    job_offer = JobOffer.find_by(identifier: params[:job_offer_identifier])

    if job_offer&.send_to_users(@preferred_users_list.users)
      redirect_back_or_to([:admin, @preferred_users_list], notice: t(".success"))
    else
      redirect_back_or_to([:admin, @preferred_users_list], notice: t(".error"))
    end
  end

  private

  def set_preferred_users_list
    @preferred_users_list = PreferredUsersList.find(params[:preferred_users_list_id])
  end

  def authorize_job_offer_sending
    authorize! :send_job_offer, @preferred_users_list
  end
end
