# frozen_string_literal: true

require "rails_helper"

RSpec.describe MultipleRecipientsEmail do
  it { should validate_presence_of(:subject) }
  it { should validate_presence_of(:body) }
  it { should validate_presence_of(:sender) }
  it { should validate_presence_of(:job_application_ids) }

  describe "#save" do
    let(:job_offer) { create(:job_offer, :with_job_applications) }
    let(:job_applications) { job_offer.job_applications }
    let(:sender) { create(:administrator) }
    subject(:multiple_recipients_email) {
      described_class.new(
        subject: "subject",
        body: "body",
        job_application_ids: job_applications.pluck(:id),
        sender: sender,
        attachments: [
          Rack::Test::UploadedFile.new(
            Rails.root.join("spec/fixtures/files/document.pdf"),
            "application/pdf"
          )
        ]
      )
    }

    it "creates one email per job application" do
      expect { multiple_recipients_email.save }.to change(Email, :count).by(job_applications.size)
    end

    it "populates created emails with the right data" do
      multiple_recipients_email.save
      job_applications.reload.each do |job_application|
        email = job_application.emails.last
        expect(email.sender).to eq(sender)
        expect(email.subject).to eq("subject")
        expect(email.body).to eq("body")
        expect(email.email_attachments.count).to eq(1)
      end
    end

    it "sends an email per job application" do
      expect {
        multiple_recipients_email.save
      }.to have_enqueued_job(ActionMailer::MailDeliveryJob).exactly(job_applications.count).times
    end
  end
end
