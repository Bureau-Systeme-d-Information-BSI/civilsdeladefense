# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::Emails::Readings" do
  let(:job_application) { create(:job_application) }

  before { sign_in create(:administrator) }

  describe "POST /admin/candidatures/:job_application_id/emails/:email_id/reading" do
    let(:email) { create(:email, job_application: job_application, is_unread: true) }

    context "when format is html" do
      subject(:create_request) { post admin_job_application_email_reading_path(job_application, email) }

      it "marks the email as read" do
        expect { create_request }.to change { email.reload.is_unread }.to(false)
      end

      it "redirects to the job application" do
        expect(create_request).to redirect_to(admin_job_application_path(job_application))
      end
    end

    context "when format is json" do
      subject(:create_request) {
        post admin_job_application_email_reading_path(job_application, email), headers: {
          "ACCEPT" => "application/json"
        }
      }

      it "marks the email as read" do
        expect { create_request }.to change { email.reload.is_unread }.to(false)
      end

      it "renders the email" do
        create_request
        expect(response.parsed_body).to match(JSON.parse(email.reload.to_json))
      end
    end

    context "when format is js" do
      subject(:create_request) { post admin_job_application_email_reading_path(job_application, email), xhr: true }

      it "marks the email as read" do
        expect { create_request }.to change { email.reload.is_unread }.to(false)
      end

      it "renders the email_operation template" do
        expect(create_request).to render_template("admin/emails/email_operation")
      end
    end
  end

  describe "DELETE /admin/candidatures/:job_application_id/emails/:email_id/reading" do
    let(:email) { create(:email, job_application: job_application, is_unread: false) }

    context "when format is html" do
      subject(:destroy_request) { delete admin_job_application_email_reading_path(job_application, email) }

      it "marks the email as unread" do
        expect { destroy_request }.to change { email.reload.is_unread }.to(true)
      end

      it "redirects to the job application" do
        expect(destroy_request).to redirect_to(admin_job_application_path(job_application))
      end
    end

    context "when format is json" do
      subject(:destroy_request) {
        delete admin_job_application_email_reading_path(job_application, email), headers: {
          "ACCEPT" => "application/json"
        }
      }

      it "marks the email as unread" do
        expect { destroy_request }.to change { email.reload.is_unread }.to(true)
      end

      it "renders the email" do
        destroy_request
        expect(response.parsed_body).to match(JSON.parse(email.reload.to_json))
      end
    end

    context "when format is js" do
      subject(:destroy_request) { delete admin_job_application_email_reading_path(job_application, email), xhr: true }

      it "marks the email as unread" do
        expect { destroy_request }.to change { email.reload.is_unread }.to(true)
      end

      it "renders the email_operation template" do
        expect(destroy_request).to render_template("admin/emails/email_operation")
      end
    end
  end
end
