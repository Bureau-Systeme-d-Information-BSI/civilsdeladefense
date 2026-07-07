# frozen_string_literal: true

class Admin::BaseController < ApplicationController
  before_action :authenticate_administrator!
  before_action :ensure_back_office_access
  load_and_authorize_resource
  layout "admin"

  protected

  def current_ability
    @current_ability ||= Ability.new(current_administrator)
  end

  def authenticated_user_or_administrator
    current_administrator || "unknown"
  end

  private

  # sign out logged in admins
  # unless they are functional_administrator
  # when BACK_OFFICE_FUNCTIONAL_ADMIN_ONLY
  def ensure_back_office_access
    return if current_administrator.authorized_for_back_office?

    sign_out(current_administrator)
    flash[:alert] = I18n.t("devise.failure.inactive")
    redirect_to new_administrator_session_path
  end
end
