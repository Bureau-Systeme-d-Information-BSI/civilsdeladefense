# frozen_string_literal: true

class Admin::JobOffers::ExportsController < Admin::BaseController
  include JobOfferStats

  skip_load_and_authorize_resource
  before_action :set_job_offer
  before_action :authorize_export

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
end
