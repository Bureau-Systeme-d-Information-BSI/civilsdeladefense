# frozen_string_literal: true

class Account::Users::FranceConnectLinksController < Account::BaseController
  def destroy
    current_user.omniauth_informations.where(provider: :france_connect).destroy_all

    redirect_to account_user_path, notice: t(".success")
  end
end
