# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do
  login_admin

  # This should return the minimal set of attributes required to create a valid
  # User. As you add validations to User, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    attributes_for(:user)
  end

  describe 'GET #show' do
    it 'returns a success response' do
      user = create(:user)
      get :show, params: { id: user.to_param }
      expect(response).to be_successful
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
      end

      it 'updates the requested user' do
        user = create(:user)

        new_attributes = {
          phone: '07'
        }

        put :update, params: { id: user.to_param, user: new_attributes }
        user.reload
        expect(user.phone).to eq('07')
      end
    end

    context 'with invalid params' do
      it "returns a success response (i.e. to display the 'edit' template)" do
        user = create(:user)

        invalid_attributes = {
          phone: ''
        }

        put :update, params: { id: user.to_param, user: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end
end
