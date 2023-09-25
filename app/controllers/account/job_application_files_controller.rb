# frozen_string_literal: true

class Account::JobApplicationFilesController < Account::BaseController
  include SendFileContent

  before_action :set_job_application
  before_action :set_job_application_file, only: %i[show update]

  layout "account/job_application_display"

  # GET /account/job_application_files
  # GET /account/job_application_files.json
  def index
  end

  def show
    if @job_application_file.document_content.blank?
      return render json: {error: "not found"}, status: :not_found
    end

    send_job_application_file_content
  end

  # POST /account/job_application_files
  # POST /account/job_application_files.json
  def create
    attrs = job_application_file_params
    @job_application_file = @job_application.job_application_files.build(attrs)
    file_type = @job_application_file.job_application_file_type

    respond_to do |format|
      if @job_application_file.save
        @job_application.compute_notifications_counter!
        format.turbo_stream do
          str = turbo_stream.replace(file_type,
            partial: "file_name_upload",
            locals: {
              job_application: @job_application,
              job_application_file: @job_application_file
            })
          render turbo_stream: str
        end
        format.html { redirect_to redirect_back_location, notice: t(".success") }
      else
        format.turbo_stream do
          render turbo_stream: turbo_stream_update_response(file_type)
        end
        format.html { redirect_to redirect_back_location, notice: t(".error") }
      end
    end
  end

  def update
    file_type = @job_application_file.job_application_file_type

    respond_to do |format|
      if @job_application_file.update(job_application_file_params.merge(is_validated: 0))
        @job_application.compute_notifications_counter!
        format.turbo_stream do
          render turbo_stream: turbo_stream_update_response(file_type)
        end
        format.html { redirect_to redirect_back_location, notice: t(".success") }
      else
        format.turbo_stream do
          render turbo_stream: turbo_stream_update_response(file_type)
        end
        format.html { redirect_to redirect_back_location, notice: t(".error") }
      end
    end
  end

  private

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

  def redirect_back_location
    [:account, @job_application, :job_application_files]
  end

  def turbo_stream_update_response(file_type)
    turbo_stream.replace(file_type,
      partial: "file_name_upload",
      locals: {
        job_application: @job_application,
        job_application_file: @job_application_file
      })
  end
end
