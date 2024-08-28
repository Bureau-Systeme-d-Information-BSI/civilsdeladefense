# frozen_string_literal: true

require "rails_helper"

RSpec.describe JobOffersController do
  describe "GET #index" do
    it "returns a success response" do
      get :index, params: {}
      expect(response).to be_successful
    end
  end

  describe "GET #show" do
    it "returns a 404 response when not published" do
      job_offer = create(:job_offer)
      get :show, params: {id: job_offer.to_param}
      expect(response).to have_http_status(:not_found)

      job_offer = create(:job_offer, state: :suspended)
      get :show, params: {id: job_offer.to_param}
      expect(response).to have_http_status(:not_found)

      job_offer = create(:job_offer, state: :archived)
      get :show, params: {id: job_offer.to_param}
      expect(response).to have_http_status(:not_found)
    end

    it "returns a success response" do
      job_offer = create(:job_offer, state: :published)
      get :show, params: {id: job_offer.to_param}
      expect(response).to be_successful
    end
  end

  describe "POST #send_application" do
    context "with logged in user and valid params" do
      login_user

      let(:valid_attributes) do
        job_application_file_type ||= create(:job_application_file_type)
        file = fixture_file_upload("document.pdf", "application/pdf")
        jaf_attrs = [
          {
            content: file,
            job_application_file_type_id: job_application_file_type.id
          }
        ]
        attributes_for(
          :job_application,
          job_application_files_attributes: jaf_attrs
        )
      end

      it "returns a success response when all fields are valid" do
        job_offer = create(:job_offer, state: :published)

        hsh = valid_attributes
        hsh[:terms_of_service] = 1
        hsh[:certify_majority] = 1
        expect {
          post :send_application, format: :json, params: {
            id: job_offer.to_param, job_application: hsh
          }
        }.to change(JobApplication, :count).by(1)
        expect(response).to be_successful
      end

      it "shoult not accept double application" do
        job_offer = create(:job_offer, state: :published)

        hsh = valid_attributes
        hsh[:terms_of_service] = 1
        hsh[:certify_majority] = 1
        expect {
          post :send_application, format: :json, params: {
            id: job_offer.to_param, job_application: hsh
          }
        }.to change(JobApplication, :count).by(1)
        expect(response).to be_successful

        hsh = valid_attributes
        file_content = fixture_file_upload("document.pdf", "application/pdf")
        hsh[:job_application_files_attributes].first[:content] = file_content
        hsh[:terms_of_service] = 1
        hsh[:certify_majority] = 1
        expect {
          post :send_application, format: :json, params: {
            id: job_offer.to_param, job_application: hsh
          }
        }.not_to change(JobApplication, :count)
        expect(response).not_to be_successful
      end
    end
  end
end
