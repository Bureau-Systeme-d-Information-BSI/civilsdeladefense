# frozen_string_literal: true

class Account::JobApplicationFilesController < Account::BaseController
  include SendFileContent

  before_action :set_job_application
  before_action :set_job_application_file, only: %i[show]

  # GET /account/job_application_files
  # GET /account/job_application_files.json
  def index
  end

  # POST /account/job_application_files
  # POST /account/job_application_files.json
  def create
    attrs = job_application_file_params
    @job_application_file = @job_application.job_application_files.build(attrs)
    @notification = t('.success')

    respond_to do |format|
      if @job_application_file.save
        @job_application.compute_notifications_counter!
        format.html { redirect_to @job_application_file, notice: @notification }
        format.js do
          render :file_operation
        end
        format.json do
          location = [:account, @job_application, @job_application_file]
          render :show, status: :created, location: location
        end
      else
        format.html { render :new }
        format.js do
          render :file_operation
        end
        format.json { render json: @job_application_file.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @job_application_file = @job_application.job_application_files.find params[:id]
    @notification = t('.success')

    respond_to do |format|
      if @job_application_file.update(job_application_file_params)
        @job_application.compute_notifications_counter!
        format.html { redirect_to @job_application_file, notice: @notification }
        format.js do
          render :file_operation
        end
        format.json do
          location = [:account, @job_application, @job_application_file]
          render :show, status: :created, location: location
        end
      else
        format.html { render :new }
        format.js do
          render :file_operation
        end
        format.json { render json: @job_application_file.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    unless @job_application_file.content.file.present?
      return render json: {
        error: 'not found'
      }, status: :not_found
    end

    send_job_application_file_content
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def job_application_file_params
    params.require(:job_application_file).permit(:job_application_file_type_id, :content)
  end

  def set_job_application
    @job_application = current_user.job_applications.find(params[:job_application_id])
    @job_offer = @job_application.job_offer
  end

  def set_job_application_file
    @job_application_file = @job_application.job_application_files.find params[:id]
  end
end
