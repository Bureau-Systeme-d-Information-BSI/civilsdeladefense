# frozen_string_literal: true

class Admin::UsersController < Admin::InheritedResourcesController
  skip_load_and_authorize_resource only: %i[show]

  def show
    load_preferred_users_list
    load_job_offer
    render layout: layout_choice
  end

  def update
    update! do |success, failure|
      success.html do
        datalake_to_job_application_profiles
        redirect_to [:admin, @user], notice: t('.success')
      end
      success.js do
        datalake_to_job_application_profiles
        @notification = t('.success')
        render :update
      end
      failure.html { render :edit }
      failure.js do
        @notification = t('.failure')
        render :update, status: :unprocessable_entity
      end
    end
  end

  protected

  def layout_choice
    'admin/pool'
  end

  def load_preferred_users_list
    return unless params[:preferred_users_list_id].present?

    id = params[:preferred_users_list_id]
    @preferred_users_list = current_administrator.preferred_users_lists.find(id)

    @user = @preferred_users_list.users.find(params[:id])
  end

  def load_job_offer
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def permitted_params
    profile_fields = %i[id gender is_currently_employed
                        availability_range_id study_level_id age_range_id
                        experience_level_id corporate_experience website_url
                        has_corporate_experience phone rejection_reason_id]
    fields = [:first_name, :last_name, { personal_profile_attributes: profile_fields }]
    params.require(:user).permit(fields)
  end

  alias resource_params permitted_params

  def datalake_to_job_application_profiles
    personal_profile = @user.personal_profile
    personal_profile&.datalake_to_job_application_profiles!
  end
end
