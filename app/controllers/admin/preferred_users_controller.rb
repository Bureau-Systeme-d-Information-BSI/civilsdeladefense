# frozen_string_literal: true

class Admin::PreferredUsersController < Admin::InheritedResourcesController
  before_action :load_preferred_users_list, except: %i[create]

  def show
    render layout: request.xhr? ? false : 'admin/pool'
  end

  def create
    create! do |success, failure|
      success.html do
        render json: {}.to_json, status: :created, location: [:admin, resource.preferred_users_list]
      end
      failure.html do
        layout_type = request.xhr? ? false : 'admin/pool'
        render action: 'new', status: :unprocessable_entity, layout: layout_type
      end
    end
  end

  def update
    update! do |success, failure|
      success.html do
        redirect_to [:admin, @preferred_user.preferred_users_list, @preferred_user]
      end
      failure.html do
        render action: 'show', status: :unprocessable_entity, layout: 'admin/pool'
      end
    end
  end

  def destroy
    destroy! do |format|
      format.html { redirect_to [:admin, @preferred_user.preferred_users_list] }
    end
  end

  protected

  def load_preferred_users_list
    return unless params[:preferred_users_list_id].present?

    id = params[:preferred_users_list_id]
    @preferred_users_list = current_administrator.preferred_users_lists.find(id)

    # @preferred_user = @preferred_users_list.preferred_users.find(params[:id])
  end

  def permitted_fields
    %i[user_id preferred_users_list_id note]
  end
end
