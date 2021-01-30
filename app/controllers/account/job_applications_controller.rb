# frozen_string_literal: true

class Account::JobApplicationsController < Account::BaseController
  before_action :set_job_application, except: %i[index]

  # GET /account/job_applications
  # GET /account/job_applications.json
  def index
    @job_applications_ongoing, @job_applications_finished = job_applications.partition do |x|
      JobApplication::FINISHED_STATES.include?(x.state)
    end
  end

  def job_offer
    render template: '/account/job_applications/show'
  end

  # GET /account/job_applications/1
  # GET /account/job_applications/1.json
  def show
    @emails = @job_application.emails.order(created_at: :desc)
    @email = @job_application.emails.new

    render layout: request.xhr? ? false : true
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
