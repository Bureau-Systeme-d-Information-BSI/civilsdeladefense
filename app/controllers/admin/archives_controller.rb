# frozen_string_literal: true

class Admin::ArchivesController < Admin::BaseController
  skip_load_and_authorize_resource
  load_and_authorize_resource :job_offer

  def new
  end

  def create
    @job_offer.attributes = job_offer_params
    @job_offer.archive!
    @notification = t(".success")
  end

  private

  def job_offer_params
    params.require(:job_offer).permit(:archiving_reason_id)
  end
end
