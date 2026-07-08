# frozen_string_literal: true

class Account::JobOffersController < Account::BaseController
  before_action :set_job_application

  def show
    @job_offer = @job_application.job_offer
    render layout: "account/job_application_display"
  end

  private

  def set_job_application
    @job_application = current_user.job_applications.find(params[:job_application_id])
  end
end
