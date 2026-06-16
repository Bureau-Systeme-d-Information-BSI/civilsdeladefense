# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::Emails" do
  let(:job_application) { create(:job_application) }

  before { sign_in create(:administrator) }

  describe "POST /admin/candidatures/:job_application_id/emails" do
    context "when the email is valid" do
      let(:params) {
        {
          email: attributes_for(:email, job_application: job_application)
        }
      }

      context "when format is html" do
        subject(:create_request) { post admin_job_application_emails_path(job_application), params: params }

        it "creates the email" do
          expect { create_request }.to change { job_application.emails.count }.by(1)
        end

        it "redirects to the job application" do
          expect(create_request).to redirect_to(admin_job_application_path(job_application))
        end
      end

      context "when format is js" do
        subject(:create_request) {
          post admin_job_application_emails_path(job_application), params: params, xhr: true
        }

        it "creates the email" do
          expect { create_request }.to change { job_application.emails.count }.by(1)
        end

        it "renders the template" do
          expect(create_request).to render_template(:create)
        end
      end
    end

    context "when the email is invalid" do
      let(:params) {
        {
          email: {subject: "subject"}
        }
      }

      context "when format is html" do
        subject(:create_request) { post admin_job_application_emails_path(job_application), params: params }

        it "doesn't create the email" do
          expect { create_request }.not_to change { job_application.emails.count }
        end

        it "renders the job application" do
          expect(create_request).to render_template("admin/job_applications/_job_application")
        end
      end

      context "when format is js" do
        subject(:create_request) {
          post admin_job_application_emails_path(job_application), params: params, xhr: true
        }

        it "doesn't create the email" do
          expect { create_request }.not_to change { job_application.emails.count }
        end

        it "renders the template" do
          expect(create_request).to render_template(:create)
        end
      end
    end
  end

  describe "GET /admin/candidatures/:job_application_id/emails/:id/attachment" do
    subject(:attachment_request) do
      get attachment_admin_job_application_email_path(job_application, email, email_attachment_id: email_attachment.id)
    end

    let(:email) { create(:email, job_application:) }
    let(:email_attachment) { create(:email_attachment, email:) }

    before { attachment_request }

    it { expect(response).to be_successful }
  end
end
