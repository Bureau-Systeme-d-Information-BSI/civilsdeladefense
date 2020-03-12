# frozen_string_literal: true

class Admin::JobApplicationFilesController < Admin::BaseController
  include SendFileContent

  load_and_authorize_resource :job_application
  load_and_authorize_resource :job_application_file, through: :job_application

  def create
    @job_application_file.do_not_provide_immediately = true
    @job_application_file.job_application = @job_application

    respond_to do |format|
      if @job_application_file.save
        format.html { redirect_to([:admin, @job_application], notice: t('.success')) }
        format.js do
          @notification = t('.success')
          render :file_operation_total
        end
        format.json do
          location = [:admin, @job_application, @job_application_file]
          render :show, status: :ok, location: location
        end
      else
        format.html { render :new }
        format.js do
          message = @job_application_file.errors.full_messages.join(', ')
          @notification = t('.failure', message: message)
          render :file_operation_total
        end
        format.json { render json: @job_application_file.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    if @job_application_file.update(job_application_file_params)
      respond_to do |format|
        format.html { redirect_to([:admin, @job_application], notice: t('.success')) }
        format.js do
          @notification = t('.success')
          render :file_operation_total
        end
        format.json do
          location = [:admin, @job_application, @job_application_file]
          render :show, status: :ok, location: location
        end
      end
    else
      respond_to do |format|
        format.html { render :new }
        format.js do
          message = @job_application_file.errors.full_messages.join(', ')
          @notification = t('.failure', message: message)
          render :file_operation_total
        end
        format.json { render json: @job_application_file.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @job_application_file.destroy

    respond_to do |format|
      format.html { redirect_to([:admin, @job_application], notice: t('.success')) }
      format.js do
        @notification = t('.success')
        render :file_operation_total
      end
      format.json { head :no_content, location: [:admin, @job_application] }
    end
  end

  def show
    unless @job_application_file.content.present?
      return render json: {
        error: 'not found'
      }, status: :not_found
    end

    send_job_application_file_content
  end

  def check
    check_and_uncheck
  end

  def uncheck
    check_and_uncheck
  end

  protected

  def check_and_uncheck
    @job_application_file.send("#{action_name}!") if %w[check uncheck].include?(action_name)
    @job_application.compute_notifications_counter!
    location = [:admin, @job_application, @job_application_file]
    @notification = t('.success')

    respond_to do |format|
      format.html do
        redirect_back(fallback_location: location, notice: @notification)
      end
      format.js do
        render :file_operation
      end
      format.json do
        render :show, status: :ok, location: location
      end
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def job_application_file_params
    params.require(:job_application_file).permit(:content,
                                                 :job_application_file_type_id,
                                                 :is_validated)
  end
end
