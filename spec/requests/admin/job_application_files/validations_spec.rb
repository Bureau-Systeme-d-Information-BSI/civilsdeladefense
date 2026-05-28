# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::JobApplicationFiles::Validations" do
  let(:job_application) { create(:job_application) }
  let(:job_application_file) { create(:job_application_file, job_application: job_application) }

  before { sign_in create(:administrator, roles: [:functional_administrator, :employer_recruiter]) }

  describe "POST /admin/candidatures/:job_application_id/job_application_files/:job_application_file_id/validation" do
    before { job_application_file.update_column(:is_validated, 2) } # rubocop:disable Rails/SkipsModelValidations

    context "when format is html" do
      subject(:create_request) {
        post admin_job_application_job_application_file_validation_path(job_application, job_application_file)
      }

      it "validates the job application file" do
        expect { create_request }.to change { job_application_file.reload.validated? }.to(true)
      end

      it "redirects to the job application file" do
        expect(create_request).to redirect_to(admin_job_application_job_application_file_path(job_application, job_application_file))
      end
    end

    context "when format is js" do
      subject(:create_request) {
        post admin_job_application_job_application_file_validation_path(job_application, job_application_file), xhr: true
      }

      it "validates the job application file" do
        expect { create_request }.to change { job_application_file.reload.validated? }.to(true)
      end

      it "renders the file_operation template" do
        expect(create_request).to render_template("admin/job_application_files/file_operation")
      end
    end

    context "when administrator is not authorized to validate" do
      let(:unauthorized_file_type) do
        create(:job_application_file_type,
          validate_by_employer_recruiter: false,
          validate_by_hr_manager: true)
      end
      let(:job_application_file) do
        create(:job_application_file, job_application: job_application, job_application_file_type: unauthorized_file_type)
      end
      let(:unauthorized_administrator) { create(:administrator, roles: [:employer_recruiter]) }

      before do
        job_application_file.update_column(:is_validated, 2) # rubocop:disable Rails/SkipsModelValidations
        create(:job_offer_actor, job_offer: job_application.job_offer, administrator: unauthorized_administrator)
        sign_in unauthorized_administrator
      end

      context "when format is html" do
        subject(:create_request) {
          post admin_job_application_job_application_file_validation_path(job_application, job_application_file)
        }

        it "redirects with alert" do
          create_request
          expect(flash[:alert]).to be_present
        end

        it "does not validate the job application file" do
          expect { create_request }.not_to change { job_application_file.reload.is_validated }
        end
      end

      context "when format is js" do
        subject(:create_request) {
          post admin_job_application_job_application_file_validation_path(job_application, job_application_file), xhr: true
        }

        it "renders the file_operation template" do
          expect(create_request).to render_template("admin/job_application_files/file_operation")
        end

        it "does not validate the job application file" do
          expect { create_request }.not_to change { job_application_file.reload.is_validated }
        end
      end
    end
  end

  describe "DELETE /admin/candidatures/:job_application_id/job_application_files/:job_application_file_id/validation" do
    before { job_application_file.update_column(:is_validated, 1) } # rubocop:disable Rails/SkipsModelValidations

    context "when format is html" do
      subject(:destroy_request) {
        delete admin_job_application_job_application_file_validation_path(job_application, job_application_file)
      }

      it "invalidates the job application file" do
        expect { destroy_request }.to change { job_application_file.reload.validated? }.to(false)
      end

      it "redirects to the job application file" do
        expect(destroy_request).to redirect_to(admin_job_application_job_application_file_path(job_application, job_application_file))
      end
    end

    context "when format is js" do
      subject(:destroy_request) {
        delete admin_job_application_job_application_file_validation_path(job_application, job_application_file), xhr: true
      }

      it "invalidates the job application file" do
        expect { destroy_request }.to change { job_application_file.reload.validated? }.to(false)
      end

      it "renders the file_operation template" do
        expect(destroy_request).to render_template("admin/job_application_files/file_operation")
      end
    end

    context "when administrator is not authorized to validate" do
      let(:unauthorized_file_type) do
        create(:job_application_file_type,
          validate_by_employer_recruiter: false,
          validate_by_hr_manager: true)
      end
      let(:job_application_file) do
        create(:job_application_file, job_application: job_application, job_application_file_type: unauthorized_file_type)
      end
      let(:unauthorized_administrator) { create(:administrator, roles: [:employer_recruiter]) }

      before do
        job_application_file.update_column(:is_validated, 1) # rubocop:disable Rails/SkipsModelValidations
        create(:job_offer_actor, job_offer: job_application.job_offer, administrator: unauthorized_administrator)
        sign_in unauthorized_administrator
      end

      context "when format is html" do
        subject(:destroy_request) {
          delete admin_job_application_job_application_file_validation_path(job_application, job_application_file)
        }

        it "redirects with alert" do
          destroy_request
          expect(flash[:alert]).to be_present
        end

        it "does not invalidate the job application file" do
          expect { destroy_request }.not_to change { job_application_file.reload.is_validated }
        end
      end

      context "when format is js" do
        subject(:destroy_request) {
          delete admin_job_application_job_application_file_validation_path(job_application, job_application_file), xhr: true
        }

        it "renders the file_operation template" do
          expect(destroy_request).to render_template("admin/job_application_files/file_operation")
        end

        it "does not invalidate the job application file" do
          expect { destroy_request }.not_to change { job_application_file.reload.is_validated }
        end
      end
    end
  end
end
