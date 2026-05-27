# frozen_string_literal: true

class Admin::JobApplicationFiles::ValidationsController < Admin::BaseController
  skip_load_and_authorize_resource
  load_and_authorize_resource :job_application
  before_action :set_job_application_file

  def create
    if @job_application_file.mark_as_valid!(current_administrator)
      @notification = t(".success")
      respond_to do |format|
        format.html { redirect_back_or_to location, notice: @notification }
        format.js { render "admin/job_application_files/file_operation" }
        format.json { render "admin/job_application_files/show", status: :ok, location: }
      end
    else
      @notification = @job_application_file.errors.full_messages.to_sentence
      respond_to do |format|
        format.html { redirect_back_or_to location, alert: @notification }
        format.js { render "admin/job_application_files/file_operation" }
        format.json { render json: @job_application_file.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if @job_application_file.mark_as_invalid!(current_administrator)
      @notification = t(".success")
      respond_to do |format|
        format.html { redirect_back_or_to location, notice: @notification }
        format.js { render "admin/job_application_files/file_operation" }
        format.json { render "admin/job_application_files/show", status: :ok, location: }
      end
    else
      @notification = @job_application_file.errors.full_messages.to_sentence
      respond_to do |format|
        format.html { redirect_back_or_to location, alert: @notification }
        format.js { render "admin/job_application_files/file_operation" }
        format.json { render json: @job_application_file.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_job_application_file
    @job_application_file = @job_application.job_application_files.find(params[:job_application_file_id])
  end

  def location = [:admin, @job_application, @job_application_file]
end
