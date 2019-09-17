# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::JobApplicationsController, type: :controller do
  login_admin

  # This should return the minimal set of attributes required to create a valid
  # JobApplication. As you add validations to JobApplication, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    attributes_for(:job_application)
  end

  let(:invalid_attributes) do
    { skills_fit_job_offer: nil }
  end

  describe 'GET #index' do
    it 'returns a success response' do
      create(:job_application)
      get :index, params: {}
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      job_application = create(:job_application)
      get :show, params: { id: job_application.to_param }
      expect(response).to be_successful
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
      end

      it 'updates the requested admin_job_application' do
        job_application = create(:job_application)

        new_attributes = {
          skills_fit_job_offer: true
        }
        put :update, params: { id: job_application.to_param, job_application: new_attributes }
        job_application.reload
        expect(job_application.skills_fit_job_offer).to be true

        new_attributes = {
          skills_fit_job_offer: false
        }
        put :update, params: { id: job_application.to_param, job_application: new_attributes }
        job_application.reload
        expect(job_application.skills_fit_job_offer).to be false
      end

      it 'redirects to the admin_job_application' do
        job_application = create(:job_application)
        put :update, params: { id: job_application.to_param, job_application: valid_attributes }
        expect(response).to redirect_to([:admin, job_application])
      end
    end
  end

  describe 'PUT #change_state' do
    context 'with valid params' do
      it 'updates the state of the requested job_application' do
        job_application = create(:job_application)
        put :change_state, params: { id: job_application.to_param, state: 'affected' }
        job_application.reload
        expect(job_application.state).to eq('affected')
      end

      it 'redirects to the admin_job_application' do
        job_application = create(:job_application)
        put :change_state, params: { id: job_application.to_param, state: 'affected' }
        expect(response).to redirect_to([:admin, job_application])
      end
    end

    context 'with invalid params' do
      it 'returns an error page' do
        job_application = create(:job_application)
        put :change_state, params: { id: job_application.to_param, state: 'non_existing_state' }
        expect(response.status).to eq(400)
      end
    end
  end
end
