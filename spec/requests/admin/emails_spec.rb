# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::Emails", type: :request do
  let(:job_application) { create(:job_application) }

  before { sign_in create(:administrator) }

  describe "POST /admin/candidatures/:job_application_id/emails/:id/mark_as_read" do
    let(:email) { create(:email, job_application: job_application, is_unread: true) }

    context "when format is html" do
      subject(:mark_as_read_request) { post mark_as_read_admin_job_application_email_path(job_application, email) }

      it "marks the email as read" do
        expect { mark_as_read_request }.to change { email.reload.is_unread }.to(false)
      end

      it "redirects to the job application" do
        expect(mark_as_read_request).to redirect_to(admin_job_application_path(job_application))
      end
    end

    context "when format is json" do
      subject(:mark_as_read_request) {
        post mark_as_read_admin_job_application_email_path(job_application, email), headers: {
          "ACCEPT" => "application/json"
        }
      }

      it "marks the email as read" do
        expect { mark_as_read_request }.to change { email.reload.is_unread }.to(false)
      end

      it "renders the email" do
        mark_as_read_request
        expect(response.parsed_body).to match(JSON.parse(email.reload.to_json))
      end
    end

    context "when format is js" do
      subject(:mark_as_read_request) { post mark_as_read_admin_job_application_email_path(job_application, email), xhr: true }

      it "marks the email as read" do
        expect { mark_as_read_request }.to change { email.reload.is_unread }.to(false)
      end

      it "renders the template" do
        expect(mark_as_read_request).to render_template(:email_operation)
      end
    end
  end

  describe "POST /admin/candidatures/:job_application_id/emails/:id/mark_as_unread" do
    let(:email) { create(:email, job_application: job_application, is_unread: false) }

    context "when format is html" do
      subject(:mark_as_unread_request) { post mark_as_unread_admin_job_application_email_path(job_application, email) }

      it "marks the email as unread" do
        expect { mark_as_unread_request }.to change { email.reload.is_unread }.to(true)
      end

      it "redirects to the job application" do
        expect(mark_as_unread_request).to redirect_to(admin_job_application_path(job_application))
      end
    end

    context "when format is json" do
      subject(:mark_as_unread_request) {
        post mark_as_unread_admin_job_application_email_path(job_application, email), headers: {
          "ACCEPT" => "application/json"
        }
      }

      it "marks the email as unread" do
        expect { mark_as_unread_request }.to change { email.reload.is_unread }.to(true)
      end

      it "renders the email" do
        mark_as_unread_request
        expect(response.parsed_body).to match(JSON.parse(email.reload.to_json))
      end
    end

    context "when format is js" do
      subject(:mark_as_unread_request) {
        post mark_as_unread_admin_job_application_email_path(job_application, email), xhr: true
      }

      it "marks the email as unread" do
        expect { mark_as_unread_request }.to change { email.reload.is_unread }.to(true)
      end

      it "renders the template" do
        expect(mark_as_unread_request).to render_template(:email_operation)
      end
    end
  end

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
end
