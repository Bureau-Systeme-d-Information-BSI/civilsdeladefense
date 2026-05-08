# frozen_string_literal: true

class Admin::JobApplications::UsersController < Admin::BaseController
  skip_load_and_authorize_resource

  before_action :set_job_application
  before_action :set_user
  before_action :authorize_update_user_info

  def update
    if @user.update(permitted_params)
      respond_to do |format|
        format.html { redirect_to admin_job_application_path(@job_application), notice: t(".success") }
        format.js do
          @notification = t(".success")
          render :update
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to admin_job_application_path(@job_application), alert: t(".failure") }
        format.js do
          @notification = t(".failure")
          render :update, status: :unprocessable_content
        end
      end
    end
  end

  private

  def set_job_application = @job_application = JobApplication.find(params[:job_application_id])

  def set_user = @user = @job_application.user

  def authorize_update_user_info
    authorization_error unless current_administrator.can?(:update_user_info, @job_application)
  end

  def permitted_params
    fields_core = %i[first_name last_name current_position phone website_url]
    fields_profile = %i[id gender is_currently_employed
      availability_range_id study_level_id age_range_id
      experience_level_id corporate_experience website_url
      has_corporate_experience]
    fields = fields_core << {profile_attributes: fields_profile}
    params.require(:user).permit(fields)
  end
end
