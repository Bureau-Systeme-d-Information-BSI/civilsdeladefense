# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::JobApplicationFiles" do
  let(:job_application) { create(:job_application) }
  let(:job_application_file) { create(:job_application_file, job_application: job_application) }

  before { sign_in create(:administrator, roles: [:functional_administrator, :employer_recruiter]) }

  describe "POST /admin/candidatures/:job_application_id/job_application_files" do
    let(:job_application_file_type) { create(:job_application_file_type) }
    let(:params) {
      {
        job_application_file: {
          job_application_file_type_id: job_application_file_type.id,
          is_validated: false
        }
      }
    }

    context "when format is html" do
      subject(:create_request) {
        post admin_job_application_job_application_files_path(job_application), params: params
      }

      it "redirects to the job application" do
        expect(create_request).to redirect_to(admin_job_application_path(job_application))
      end

      it "creates the job application file" do
        expect { create_request }.to change(JobApplicationFile, :count).by(1)
      end
    end

    context "when format is js" do
      subject(:create_request) {
        post admin_job_application_job_application_files_path(job_application), params: params, xhr: true
      }

      it "renders the template" do
        expect(create_request).to render_template(:file_operation_total)
      end

      it "creates the job application file" do
        expect { create_request }.to change(JobApplicationFile, :count).by(1)
      end
    end
  end

  describe "PATCH /admin/candidatures/:job_application_id/job_application_files/:id" do
    let(:job_application_file_type) { create(:job_application_file_type) }
    let(:params) {
      {
        job_application_file: {
          job_application_file_type_id: job_application_file_type.id,
          is_validated: false
        }
      }
    }

    context "when format is html" do
      subject(:update_request) {
        patch admin_job_application_job_application_file_path(job_application, job_application_file), params: params
      }

      it "redirects to the job application" do
        expect(update_request).to redirect_to(admin_job_application_path(job_application))
      end

      it "updates the job application file" do
        expect {
          update_request
        }.to change { job_application_file.reload.job_application_file_type }.to(job_application_file_type)
      end
    end

    context "when format is js" do
      subject(:update_request) {
        patch admin_job_application_job_application_file_path(job_application, job_application_file),
          params: params,
          xhr: true
      }

      it "renders the template" do
        expect(update_request).to render_template(:file_operation_total)
      end

      it "updates the job application file" do
        expect {
          update_request
        }.to change { job_application_file.reload.job_application_file_type }.to(job_application_file_type)
      end
    end
  end

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

  describe "DELETE /admin/candidatures/:job_application_id/job_application_files/:id" do
    context "when format is html" do
      subject(:destroy_request) {
        delete admin_job_application_job_application_file_path(job_application, job_application_file)
      }

      it "redirects to the job application" do
        destroy_request
        expect(destroy_request).to redirect_to(admin_job_application_path(job_application))
      end

      it "destroys the job application file" do
        destroy_request
        expect { job_application_file.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context "when format is js" do
      subject(:destroy_request) {
        delete admin_job_application_job_application_file_path(job_application, job_application_file), xhr: true
      }

      it "renders the template" do
        destroy_request
        expect(destroy_request).to render_template(:file_operation_total)
      end

      it "destroys the job application file" do
        destroy_request
        expect { job_application_file.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context "when format is json" do
      subject(:destroy_request) {
        delete admin_job_application_job_application_file_path(job_application, job_application_file), headers: {
          "ACCEPT" => "application/json"
        }
      }

      it "returns no_content" do
        destroy_request
        expect(response).to have_http_status(:no_content)
      end

      it "destroys the job application file" do
        destroy_request
        expect { job_application_file.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe "POST /admin/candidatures/:job_application_id/job_application_files when the file is invalid" do
    let(:file_type) { create(:job_application_file_type) }
    let(:params) { {job_application_file: {job_application_file_type_id: file_type.id, is_validated: false}} }

    before { create(:job_application_file, job_application:, job_application_file_type: file_type) }

    context "when format is html" do
      subject(:create_request) { post admin_job_application_job_application_files_path(job_application), params: }

      # No "new" template exists, so the html failure branch raises a missing template error.
      it { expect { create_request }.to raise_error(ActionView::MissingTemplate) }
    end

    context "when format is js" do
      subject(:create_request) {
        post admin_job_application_job_application_files_path(job_application), params:, xhr: true
      }

      before { create_request }

      it { expect(response).to render_template(:file_operation_total) }
    end

    context "when format is json" do
      subject(:create_request) { post admin_job_application_job_application_files_path(job_application, format: :json), params: }

      before { create_request }

      it { expect(response).to have_http_status(:unprocessable_content) }
    end
  end

  describe "PATCH /admin/candidatures/:job_application_id/job_application_files/:id when the file is invalid" do
    let(:other_file_type) { create(:job_application_file_type, name: "Diploma") }
    let(:params) { {job_application_file: {job_application_file_type_id: other_file_type.id}} }

    before do
      job_application_file
      create(:job_application_file, job_application:, job_application_file_type: other_file_type)
    end

    context "when format is html" do
      subject(:update_request) { patch admin_job_application_job_application_file_path(job_application, job_application_file), params: }

      # No "new" template exists, so the html failure branch raises a missing template error.
      it { expect { update_request }.to raise_error(ActionView::MissingTemplate) }
    end

    context "when format is js" do
      subject(:update_request) {
        patch admin_job_application_job_application_file_path(job_application, job_application_file), params:, xhr: true
      }

      before { update_request }

      it { expect(response).to render_template(:file_operation_total) }
    end

    context "when format is json" do
      subject(:update_request) {
        patch admin_job_application_job_application_file_path(job_application, job_application_file, format: :json),
          params:
      }

      before { update_request }

      it { expect(response).to have_http_status(:unprocessable_content) }
    end
  end

  describe "DELETE /admin/candidatures/:job_application_id/job_application_files/:id when it cannot be unrequested" do
    let(:required_file_type) { create(:job_application_file_type, required: true) }
    let(:job_application_file) {
      create(:job_application_file, job_application:, job_application_file_type: required_file_type)
    }

    context "when format is js" do
      subject(:destroy_request) {
        delete admin_job_application_job_application_file_path(job_application, job_application_file), xhr: true
      }

      before { destroy_request }

      it { expect(response).to render_template(:file_operation_total) }
    end

    context "when format is html" do
      subject(:destroy_request) {
        delete admin_job_application_job_application_file_path(job_application, job_application_file)
      }

      it { expect(destroy_request).to redirect_to(admin_job_application_path(job_application)) }
    end
  end
end
