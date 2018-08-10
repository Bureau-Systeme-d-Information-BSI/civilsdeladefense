class JobOffersController < ApplicationController
  before_action :set_job_offer, only: [:show, :apply]

  # GET /job_offers
  # GET /job_offers.json
  def index
    @categories = Category.order(name: :asc).joins(:job_offers).uniq
  end

  # GET /job_offers/1
  # GET /job_offers/1.json
  def show
  end

  # GET /job_offers/1/apply
  # GET /job_offers/1/apply.json
  def apply
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_job_offer
      @job_offer = JobOffer.find(params[:id])
      if params[:id] != @job_offer.slug
        return redirect_to @job_offer, status: :moved_permanently
      end
    end
end
