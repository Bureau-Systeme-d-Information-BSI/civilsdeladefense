# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::JobApplicationFiles", type: :request do
  let(:job_application_file) { create(:job_application_file) }
  let(:job_application) { job_application_file.job_application }

  before { sign_in create(:administrator) }

  describe "GET /admin/candidatures/:job_application_id/job_application_files/:id" do
    subject(:show_request) {
      get admin_job_application_job_application_file_path(job_application, job_application_file)
    }

    it "sends the job application file content" do
      show_request
      expect(response.headers["Content-Type"]).to eq("application/pdf")
    end

    it "renders an error when the job application file content is not found" do
      job_application_file
      allow_any_instance_of(JobApplicationFile).to receive(:content).and_return(nil)

      show_request
      expect(response).to have_http_status(:not_found)
    end
  end
end
