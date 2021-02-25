# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :verify_authenticity_token, only: :france_connect
  rescue_from Rack::OAuth2::Client::Error, with: :oauth_error

  def france_connect
    auth = request.env["omniauth.auth"]

    @omniauth_info = OmniauthInformation.find_or_initialize_by(
      uid: auth.uid, provider: :france_connect
    )
    @omniauth_info.assign_attributes(
      email: auth.info.email,
      first_name: auth.info.first_name,
      last_name: auth.info.last_name
    )

    retrieve_user

    @omniauth_info.save!
    sign_in_user
  end

  protected

  def sign_in_user
    sign_in @user

    session[:connected_with] = "france_connect"

    path = after_sign_in_path_for(current_user) || root_path(current_user)
    redirect_to(path)
  end

  def retrieve_user
    user_by_email = User.find_or_initialize_by(email: @omniauth_info.email)
    @user = @omniauth_info.user || current_user || user_by_email
    @user.omniauth_informations << @omniauth_info

    return unless @user.new_record?

    @user.update!(
      confirmed_at: Time.zone.now,
      last_name: @omniauth_info.last_name,
      first_name: @omniauth_info.first_name,
      organization: current_organization
    )
  end

  def oauth_error(error)
    Rails.logger.error error.message

    flash.alert = t("errors.messages.france_connect.connexion")
    redirect_to(new_user_session_path)
  end
end
