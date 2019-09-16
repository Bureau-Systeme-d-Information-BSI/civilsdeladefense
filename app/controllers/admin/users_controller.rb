# frozen_string_literal: true

class Admin::UsersController < Admin::InheritedResourcesController
  skip_load_and_authorize_resource only: %i[show]

  def show
    load_preferred_users_list
    load_job_offer
    render layout: layout_choice
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
end
