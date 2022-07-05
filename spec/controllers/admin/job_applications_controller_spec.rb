# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::JobApplicationsController, type: :controller do
  # This should return the minimal set of attributes required to create a valid
  # JobApplication. As you add validations to JobApplication, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    attributes_for(:job_application)
  end

  let(:invalid_attributes) do
    {skills_fit_job_offer: nil}
  end

  let!(:job_application) { create(:job_application) }

  context "when logged in as BANT administrator" do
    login_admin

    describe "GET #index" do
      it "returns a success response" do
        get :index, params: {}
        expect(response).to be_successful
      end
    end

    describe "GET #show" do
      it "returns a success response" do
        get :show, params: {id: job_application.to_param}
        expect(response).to be_successful
      end
    end

    describe "PUT #update" do
      context "with valid params" do
        it "updates the requested admin_job_application" do
          new_attributes = {
            skills_fit_job_offer: true
          }
          put :update, params: {id: job_application.to_param, job_application: new_attributes}
          job_application.reload
          expect(job_application.skills_fit_job_offer).to be true

          new_attributes = {
            skills_fit_job_offer: false
          }
          put :update, params: {id: job_application.to_param, job_application: new_attributes}
          job_application.reload
          expect(job_application.skills_fit_job_offer).to be false
        end

        it "redirects to the admin_job_application" do
          put :update, params: {id: job_application.to_param, job_application: valid_attributes}
          expect(response).to redirect_to([:admin, job_application])
        end
      end
    end

    describe "PUT #change_state" do
      context "with valid params" do
        it "updates the state of the requested job_application" do
          put :change_state, params: {id: job_application.to_param, state: "affected"}
          job_application.reload
          expect(job_application.state).to eq("affected")
        end

        it "redirects to the admin_job_application" do
          put :change_state, params: {id: job_application.to_param, state: "affected"}
          expect(response).to redirect_to([:admin, job_application])
        end
      end

      context "with invalid params" do
        it "returns an error page" do
          put :change_state, params: {id: job_application.to_param, state: "non_existing_state"}
          expect(response.status).to eq(400)
        end
      end
    end
  end

  context "when logged in as CMG administrator" do
    login_cmg

    before do
      create(
        :job_offer_actor,
        administrator: subject.current_administrator, # rubocop:disable RSpec/NamedSubject
        job_offer: job_application.job_offer,
        role: :cmg
      )
    end

    describe "GET #index" do
      it "returns a success response" do
        get :index, params: {}
        expect(response).to be_successful
      end
    end

    describe "GET #show" do
      it "returns a success response" do
        get :show, params: {id: job_application.to_param}
        expect(response).to be_successful
      end
    end

    describe "PUT #update" do
      context "with valid params" do
        it "updates the requested admin_job_application" do
          new_attributes = {
            skills_fit_job_offer: true
          }
          put :update, params: {id: job_application.to_param, job_application: new_attributes}
          job_application.reload
          expect(job_application.skills_fit_job_offer).to be true

          new_attributes = {
            skills_fit_job_offer: false
          }
          put :update, params: {id: job_application.to_param, job_application: new_attributes}
          job_application.reload
          expect(job_application.skills_fit_job_offer).to be false
        end

        it "redirects to the admin_job_application" do
          put :update, params: {id: job_application.to_param, job_application: valid_attributes}
          expect(response).to redirect_to([:admin, job_application])
        end
      end
    end

    describe "PUT #change_state" do
      context "with valid params" do
        it "updates the state of the requested job_application" do
          put :change_state, params: {id: job_application.to_param, state: "affected"}
          job_application.reload
          expect(job_application.state).to eq("affected")
        end

        it "redirects to the admin_job_application" do
          put :change_state, params: {id: job_application.to_param, state: "affected"}
          expect(response).to redirect_to([:admin, job_application])
        end
      end

      context "with invalid params" do
        it "returns an error page" do
          put :change_state, params: {id: job_application.to_param, state: "non_existing_state"}
          expect(response.status).to eq(400)
        end
      end
    end
  end
end
