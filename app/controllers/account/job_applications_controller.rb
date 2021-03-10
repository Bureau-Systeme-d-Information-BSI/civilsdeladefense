# frozen_string_literal: true

class Account::JobApplicationsController < Account::BaseController
  before_action :set_job_application, except: %i[index]

  # GET /account/job_applications
  # GET /account/job_applications.json
  def index
    @job_applications_ongoing = job_applications.where.not(state: JobApplication::FINISHED_STATES)
    @job_applications_finished = job_applications.where(state: JobApplication::FINISHED_STATES)
  end

  def job_offer
    render layout: "account/job_application_display"
  end

  # GET /account/job_applications/1
  # GET /account/job_applications/1.json
  def show
    @emails = @job_application.emails.order(created_at: :desc)
    @email = @job_application.emails.new

    render layout: "account/job_application_display"
  end

  private

  def job_applications
    current_user.job_applications.includes(job_offer: [:contract_type]).order(created_at: :desc)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_job_application
    id = params[:job_application_id] || params[:id]
    @job_application = current_user.job_applications.find(id)
    @job_offer = @job_application.job_offer
  end
end
