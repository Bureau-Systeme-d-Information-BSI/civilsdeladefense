# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]

  def success
    @email = params[:email]
    @contact_page = Page.contact
  end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    permitted_params = %i[
      first_name last_name terms_of_service certify_majority current_position phone
      website_url
    ]
    devise_parameter_sanitizer.permit(:sign_up, keys: permitted_params)
  end

  def build_resource(hash = {})
    super
    resource.organization = current_organization
  end

  def after_inactive_sign_up_path_for(resource)
    flash.notice = nil
    success_user_registration_path(email: resource.email)
  end
end
