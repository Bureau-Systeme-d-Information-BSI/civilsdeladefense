# frozen_string_literal: true

class Admin::Users::JobOfferSendingsController < Admin::BaseController
  skip_load_and_authorize_resource
  before_action :set_user
  before_action :authorize_job_offer_sending

  def create
    job_offer = JobOffer.find_by(identifier: params[:job_offer_identifier])

    if job_offer&.send_to_users([@user])
      redirect_back_or_to([:admin, @user], notice: t(".success"))
    else
      redirect_back_or_to([:admin, @user], notice: t(".error"))
    end
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def authorize_job_offer_sending
    authorize! :send_job_offer, @user
  end
end
