# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Account::JobApplications" do
  let(:user) { create(:confirmed_user) }

  before { sign_in user }

  describe "GET /espace-candidat/mes-candidatures" do
    subject(:index_request) { get account_job_applications_path }

    it "is successful" do
      index_request
      expect(response).to be_successful
    end

    it "renders the template" do
      expect(index_request).to render_template(:index)
    end
  end

  describe "GET /espace-candidat/mes-candidatures/:id" do
    subject(:show_request) { get account_job_application_path(job_application) }

    let(:job_application) { create(:job_application, user: user) }

    it "is successful" do
      show_request
      expect(response).to be_successful
    end

    it "renders the template" do
      expect(show_request).to render_template(:show)
    end
  end
end
