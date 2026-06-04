# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::JobApplicationFilesController do
  describe "DELETE #destroy" do
    login_admin

    subject(:destroy_file) do
      delete :destroy, params: {job_application_id: job_application.to_param, id: job_application_file.to_param}
    end

    let(:job_application) { create(:job_application) }
    let(:job_application_file_type) { create(:job_application_file_type, required:) }
    let!(:job_application_file) do
      create(:job_application_file, job_application:, job_application_file_type:)
    end

    context "when the file type is not required by default" do
      let(:required) { false }

      it { expect { destroy_file }.to change(JobApplicationFile, :count).by(-1) }
    end

    context "when the file type is required by default" do
      let(:required) { true }

      it { expect { destroy_file }.not_to change(JobApplicationFile, :count) }
    end
  end
end
