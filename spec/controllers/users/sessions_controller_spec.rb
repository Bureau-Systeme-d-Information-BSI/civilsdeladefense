# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::SessionsController, type: :controller do
  describe 'DELETE /destroy' do
    login_user

    context 'when user is connected' do
      before do
        delete :destroy
      end

      it 'redirect_to root_url' do
        expect(response).to redirect_to(root_url)
      end
    end

    context 'when user is connected via FranceConnect' do
      before do
        @request.session['connected_with'] = 'france_connect'
        delete :destroy
      end

      it 'redirect_to france_connect end_session_endpoint' do
        expect(response).to redirect_to(FranceConnectClient.end_session_endpoint)
      end
    end
  end
end
