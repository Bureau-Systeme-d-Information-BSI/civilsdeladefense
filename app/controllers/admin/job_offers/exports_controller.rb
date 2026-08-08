# frozen_string_literal: true

class Admin::JobOffers::ExportsController < Admin::BaseController
  include JobOfferStats

  skip_load_and_authorize_resource
  before_action :authorize_exports, only: :index
  before_action :set_job_offer, only: :show
  before_action :authorize_export, only: :show

  def index
    job_offers = params[:select_all].present? ? JobOffer.all : JobOffer.where(id: params[:job_offer_ids])
    file = Exporter::JobOffers.new(job_offers, current_administrator).generate

    send_data file.read, filename: "#{Time.zone.today}_e-recrutement_offres.xlsx"
  end

  def show
    file = Exporter::JobOffer.new({stats: export_data, job_offer: @job_offer}, current_administrator).generate

    send_data file.read, filename: "#{Time.zone.today}_e-recrutement_offre.xlsx"
  end

  private

  def set_job_offer
    @job_offer = JobOffer.find(params[:job_offer_id])
  end

  def authorize_export
    authorize! :export, @job_offer
  end

  def authorize_exports
    authorize! :exports, JobOffer
  end
end
