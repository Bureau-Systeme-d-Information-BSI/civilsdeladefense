# frozen_string_literal: true

class Admin::PreferredUsersController < Admin::InheritedResourcesController
  def destroy
    if @preferred_user.destroy
      redirect_back_or_to([:admin, @preferred_user.preferred_users_list], notice: t(".success"))
    else
      redirect_back_or_to([:admin, @preferred_user.preferred_users_list], notice: t(".error"))
    end
  end
end
