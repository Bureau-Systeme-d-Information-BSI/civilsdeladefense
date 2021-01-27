# frozen_string_literal: true

class OmniauthCallbacksController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :france_connect
  rescue_from Rack::OAuth2::Client::Error, with: :oauth_error

  def france_connect
    user_info = FranceConnectClient.new(params[:code]).user_info

    @fc_info = FranceConnectInformation.find_or_initialize_by(sub: user_info[:sub])
    @fc_info.assign_attributes(
      user_info.slice(:email, :family_name, :given_name)
    )

    retrieve_user

    @fc_info.save
    sign_in_user
  end

  protected

  def sign_in_user
    sign_in @user

    session[:connected_with] = 'france_connect'

    path = after_sign_in_path_for(current_user) || root_path(current_user)
    redirect_to(path)
  end

  def retrieve_user
    @user = @fc_info.user || current_user || User.find_or_initialize_by(email: @fc_info.email)
    @user.france_connect_informations << @fc_info

    return unless @user.new_record?

    @user.update(
      confirmed_at: Time.zone.now,
      last_name: @fc_info.family_name,
      first_name: @fc_info.given_name,
      organization: current_organization,
      current_position: 'N/C',
      phone: 'N/C'
    )
  end

  def oauth_error(error)
    Rails.logger.error error.message

    flash.alert = t('errors.messages.france_connect.connexion')
    redirect_to(new_user_session_path)
  end
end
