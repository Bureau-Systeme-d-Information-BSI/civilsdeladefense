# frozen_string_literal: true

class Admin::JobOffers::BoardsController < Admin::BaseController
  skip_load_and_authorize_resource
  before_action :set_job_offer
  before_action :authorize_board
  layout "admin/job_offer_single"

  def show
    @job_applications = @job_offer.job_applications.not_rejecteds.includes(:user).group_by(&:state)
    @rejecteds = @job_offer.job_applications.rejecteds
    request.xhr? && render(layout: false)
  end

  private

  def set_job_offer
    @job_offer = JobOffer.find(params[:job_offer_id])
  end

  def authorize_board
    authorize! :board, @job_offer
  end
end
