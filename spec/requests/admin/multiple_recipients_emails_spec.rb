# frozen_string_literal: true

require "rails_helper"

RSpec.describe "MultipleRecipientsEmails" do
  let(:job_offer) { create(:job_offer, :with_job_applications) }
  let(:job_applications) { job_offer.job_applications }

  before { sign_in create(:administrator) }

  describe "GET /new" do
    it "shows the multiple recipients email form" do
      get new_admin_job_offer_multiple_recipients_email_path(job_offer)
      expect(response).to be_successful
    end

    it "filters recipients on the initial state when no state is given" do
      get new_admin_job_offer_multiple_recipients_email_path(job_offer)
      job_applications.initial.map(&:user).map(&:full_name).each do |name|
        expect(response.body).to include(name)
      end
    end

    it "filters recipients on the given state" do
      job_applications << create(:job_application, state: :contract_received)

      get new_admin_job_offer_multiple_recipients_email_path(job_offer, state: :contract_received)

      job_applications.initial.map(&:user).map(&:full_name).each do |name|
        expect(response.body).not_to include(name)
      end

      job_applications.contract_received.map(&:user).map(&:full_name).each do |name|
        expect(response.body).to include(name)
      end
    end

    it "filters out job applications with missing users" do
      job_applications.last.user.destroy!

      get new_admin_job_offer_multiple_recipients_email_path(job_offer)
      job_applications.initial.with_user.map(&:user).map(&:full_name).each do |name|
        expect(response.body).to include(name)
      end
    end

    it "disables the form when the job offer is archived" do
      get new_admin_job_offer_multiple_recipients_email_path(job_offer)
      expect(response.body).not_to include("disabled")

      job_offer.archive!

      get new_admin_job_offer_multiple_recipients_email_path(job_offer)
      expect(response.body).to include("disabled")
    end
  end

  describe "POST /create" do
    let(:params) {
      {
        multiple_recipients_email: {
          job_application_ids: job_applications.pluck(:id),
          subject: "subject",
          body: "body",
          attachments: [
            Rack::Test::UploadedFile.new(
              Rails.root.join("spec/fixtures/files/document.pdf"),
              "application/pdf"
            )
          ]
        }
      }
    }

    it "creates emails" do
      expect {
        post admin_job_offer_multiple_recipients_emails_path(job_offer), params: params
      }.to change(Email, :count).by(job_applications.count)

      job_applications.reload.each do |job_application|
        email = job_application.emails.last
        expect(email.subject).to eq(params[:multiple_recipients_email][:subject])
        expect(email.body).to eq(params[:multiple_recipients_email][:body])
        expect(email.email_attachments.count).to eq(1)
      end
    end

    it "sends emails" do
      expect {
        post admin_job_offer_multiple_recipients_emails_path(job_offer), params: params
      }.to have_enqueued_job(ActionMailer::MailDeliveryJob).exactly(job_applications.count).times
    end

    it "redirects to the job offer" do
      post admin_job_offer_multiple_recipients_emails_path(job_offer), params: params
      expect(response).to redirect_to([:board, :admin, job_offer])
    end

    describe "edge cases" do
      context "when parameters are missing" do
        let(:params) {
          {
            multiple_recipients_email: {
              subject: "subject"
            }
          }
        }

        it "renders new with errors" do
          post admin_job_offer_multiple_recipients_emails_path(job_offer), params: params
          expect(response).to be_successful
          expect(response.body).to include("Veuillez corriger les champs ci-dessous")
        end
      end
    end
  end
end
