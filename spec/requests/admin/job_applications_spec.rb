# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::JobApplications" do
  let(:job_application) { create(:job_application) }

  before { sign_in create(:administrator) }

  describe "GET /admin/job_applications" do
    subject(:index_request) { get admin_job_applications_path }

    before { index_request }

    it { expect(response).to have_http_status(:ok) }
  end

  describe "GET /admin/job_applications with a full text search" do
    subject(:index_request) { get admin_job_applications_path(s: job_application.user.last_name) }

    before { index_request }

    it { expect(response).to have_http_status(:ok) }
  end

  describe "GET /admin/job_applications/:id" do
    subject(:show_request) { get admin_job_application_path(job_application) }

    before { show_request }

    it { expect(response).to have_http_status(:ok) }
  end

  describe "GET /admin/job_applications/:id when the user has been deleted" do
    subject(:show_request) { get admin_job_application_path(job_application) }

    before do
      job_application.update!(user: nil)
      show_request
    end

    it { expect(response).to redirect_to(admin_job_offer_path(job_application.job_offer)) }
  end

  describe "GET /admin/job_offers/:job_offer_id/candidatures/:id" do
    subject(:show_request) do
      get admin_job_offer_job_application_path(job_application.job_offer, job_application)
    end

    before { show_request }

    it { expect(response).to have_http_status(:ok) }
  end

  describe "PATCH /admin/job_applications/:id" do
    subject(:update_request) do
      patch admin_job_application_path(job_application), params: {job_application: {skills_fit_job_offer: true}}
    end

    context "when format is html" do
      it { expect(update_request).to redirect_to([:admin, job_application]) }
    end

    context "when format is js" do
      subject(:update_request) do
        patch admin_job_application_path(job_application),
          params: {job_application: {skills_fit_job_offer: true}},
          xhr: true
      end

      before { update_request }

      it { expect(response).to render_template(:update) }
    end
  end

  describe "PATCH /admin/job_applications/:id when the update fails" do
    before do
      allow_any_instance_of(JobApplication).to receive(:update).and_return(false)
      update_request
    end

    context "when format is html" do
      subject(:update_request) do
        patch admin_job_application_path(job_application), params: {job_application: {skills_fit_job_offer: true}}
      end

      it { expect(response).to render_template(:edit) }
    end

    context "when format is js" do
      subject(:update_request) do
        patch admin_job_application_path(job_application),
          params: {job_application: {skills_fit_job_offer: true}},
          xhr: true
      end

      it { expect(response).to have_http_status(:unprocessable_content) }
    end
  end

  describe "PATCH /admin/job_applications/:id/change_state as js" do
    subject(:change_state_request) do
      patch change_state_admin_job_application_path(job_application), params: {state: "phone_meeting"}, xhr: true
    end

    before { change_state_request }

    it { expect(response).to render_template(:change_state) }
  end

  describe "PATCH /admin/job_applications/:id/change_state when the transition is invalid" do
    subject(:change_state_request) do
      patch change_state_admin_job_application_path(job_application), params: {state: "phone_meeting"}
    end

    before do
      allow_any_instance_of(Administrator).to receive(:can_change_state?).and_return(true)
      allow_any_instance_of(JobApplication).to receive(:phone_meeting!).and_raise(ActiveRecord::RecordInvalid)
      change_state_request
    end

    it { expect(response).to redirect_to([:admin, job_application]) }
  end
end
