# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Account::JobApplicationFiles", type: :request do
  let(:user) { create(:confirmed_user) }
  let(:job_application) { create(:job_application, user: user) }
  let(:job_application_file) { create(:job_application_file, job_application: job_application) }
  let(:job_application_file_type) { create(:job_application_file_type) }

  before { sign_in user }

  describe "GET /espace-candidat/mes-candidatures/:job_application_id/documents" do
    it "renders the template" do
      get account_job_application_job_application_files_path(job_application)
      expect(response).to render_template(:index)
    end
  end

  describe "POST /espace-candidat/mes-candidatures/:job_application_id/documents" do
    let(:params) {
      {
        job_application_file: {
          job_application_file_type_id: job_application_file_type.id,
          content: Rack::Test::UploadedFile.new(
            Rails.root.join("spec/fixtures/files/document.pdf"),
            "application/pdf"
          )
        }
      }
    }

    context "when format is html" do
      subject(:create_request) {
        post account_job_application_job_application_files_path(job_application), params: params
      }

      it "redirects to the job application files" do
        expect(create_request).to redirect_to(account_job_application_job_application_files_path(job_application))
      end

      it "creates a job application file" do
        expect { create_request }.to change(job_application.job_application_files, :count).by(1)
      end

      it "doesn't create a job application file when it's invalid" do
        allow_any_instance_of(JobApplicationFile).to receive(:save).and_return(false)
        expect { create_request }.not_to change(job_application.job_application_files, :count)
      end
    end

    context "when format is turbo" do
      subject(:create_request) {
        post account_job_application_job_application_files_path(job_application), params: params, as: :turbo_stream
      }

      it "renders the turbo_stream" do
        create_request
        expect(response).to be_successful
        expect(response.media_type).to eq Mime[:turbo_stream]
        expect(response).to render_template(layout: false)
        expect(response.body).to include('<turbo-stream action="replace"')
      end

      it "creates a job application file" do
        expect { create_request }.to change(job_application.job_application_files, :count).by(1)
      end

      it "doesn't create a job application file when it's invalid" do
        allow_any_instance_of(JobApplicationFile).to receive(:save).and_return(false)
        expect { create_request }.not_to change(job_application.job_application_files, :count)
      end
    end
  end

  describe "PATCH /espace-candidat/mes-candidatures/:job_application_id/documents/:id" do
    let(:params) {
      {
        job_application_file: {
          job_application_file_type_id: job_application_file_type.id
        }
      }
    }

    context "when format is html" do
      subject(:update_request) {
        patch account_job_application_job_application_file_path(job_application, job_application_file), params: params
      }

      it "redirects to the job application files" do
        expect(update_request).to redirect_to(account_job_application_job_application_files_path(job_application))
      end

      it "updates the job application file" do
        expect {
          update_request
        }.to change { job_application_file.reload.job_application_file_type }.to(job_application_file_type)
      end

      it "doesn't update the job application file when it's invalid" do
        allow_any_instance_of(JobApplicationFile).to receive(:update).and_return(false)
        expect { update_request }.not_to change(job_application_file, :job_application_file_type)
      end
    end

    context "when format is turbo_stream" do
      subject(:update_request) {
        patch account_job_application_job_application_file_path(
          job_application,
          job_application_file
        ), params: params, as: :turbo_stream
      }

      it "renders the turbo_stream" do
        update_request
        expect(response).to be_successful
        expect(response.media_type).to eq Mime[:turbo_stream]
        expect(response).to render_template(layout: false)
        expect(response.body).to include('<turbo-stream action="replace"')
      end

      it "updates the job application file" do
        expect {
          update_request
        }.to change { job_application_file.reload.job_application_file_type }.to(job_application_file_type)
      end

      it "doesn't update the job application file when it's invalid" do
        allow_any_instance_of(JobApplicationFile).to receive(:update).and_return(false)
        expect { update_request }.not_to change(job_application_file, :job_application_file_type)
      end
    end
  end

  describe "GET /espace-candidat/mes-candidatures/:job_application_id/documents/:id" do
    subject(:show_request) {
      get account_job_application_job_application_file_path(job_application, job_application_file)
    }

    it "returns the file" do
      show_request
      expect(response.headers["Content-Type"]).to eq("application/pdf")
    end

    it "returns a not_found error when the file doesn't exist" do
      job_application_file
      allow_any_instance_of(DocumentUploader).to receive(:file).and_return(nil)
      show_request
      expect(response).to have_http_status(:not_found)
    end
  end
end
