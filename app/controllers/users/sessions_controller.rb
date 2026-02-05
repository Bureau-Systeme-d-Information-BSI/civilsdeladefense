# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  def destroy
    connected_with_france_connect = session[:connected_with] == "france_connect"
    id_token = current_user&.omniauth_informations&.find_by(provider: :france_connect)&.id_token

    super do
      if connected_with_france_connect && id_token.present?
        return redirect_to france_connect_logout_url(id_token), allow_other_host: true
      end
    end
  end

  private

  def france_connect_logout_url(id_token)
    host = ENV.fetch("FRANCE_CONNECT_HOST")
    state = SecureRandom.hex(16)
    post_logout_redirect_uri = CGI.escape(ENV.fetch("DEFAULT_HOST"))

    "https://#{host}/api/v2/session/end?" \
      "id_token_hint=#{id_token}&" \
      "state=#{state}&" \
      "post_logout_redirect_uri=#{post_logout_redirect_uri}"
  end
end
