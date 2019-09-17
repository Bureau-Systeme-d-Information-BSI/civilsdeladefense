# frozen_string_literal: true

class Admin::PreferredUsersController < Admin::InheritedResourcesController
  def show
    render layout: request.xhr? ? false : 'admin/simple'
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

  def destroy
    destroy! do |format|
      format.html { redirect_to [:admin, @preferred_user.preferred_users_list] }
    end
  end

  protected

  def permitted_fields
    %i[user_id preferred_users_list_id]
  end
end
