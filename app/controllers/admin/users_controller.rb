# frozen_string_literal: true

class Admin::UsersController < Admin::InheritedResourcesController
  # skip_load_and_authorize_resource only: %i[show]

  def index
    @q = @users.ransack(params[:q])
    @users_filtered = @q.result.yield_self do |relation|
      if params[:s].present?
        relation.search_full_text(params[:s])
      else
        relation
      end
    end.yield_self do |relation|
      relation.includes(:last_job_application).paginate(page: params[:page], per_page: 25)
    end

    render action: :index, layout: 'admin/pool'
  end

  def show
    load_preferred_users_list
    render layout: layout_choice
  end

  def update
    update! do |success, failure|
      success.html do
        redirect_to [:admin, @user], notice: t('.success')
      end
      success.js do
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

  # Never trust parameters from the scary internet, only allow the white list through.
  def permitted_params
    fields = %i[first_name last_name current_position phone website_url]
    params.require(:user).permit(fields)
  end

  alias resource_params permitted_params
end
