# frozen_string_literal: true

require "rails_helper"

RSpec.describe ApplicantNotificationsMailer do
  describe "new_email" do
    let(:job_offer) { create(:job_offer) }
    let(:organization) { job_offer.organization }
    let(:job_application) { create(:job_application, job_offer: job_offer) }
    let(:email) { create(:email, job_application: job_application) }
    let(:mail) { described_class.new_email(email.id) }

    context "when from organization without inbound email configured" do
      it "renders the headers" do
        expect(mail.subject).to eq("New email")
        expect(mail.to).to eq([job_application.user.email])
        expect(mail.from).to eq(["hello@localhost"])
      end

      it "renders the body" do
        expect(mail.body.encoded).to match(/Vous recevez ce message parce que vous avez candidat/)
      end
    end

    context "when from organization with inbound email configured with catch_all" do
      before do
        organization.inbound_email_config = :catch_all
        organization.save
      end

      it "change the reply_to email" do
        expect(mail.subject).to eq("New email")
        expect(mail.to).to eq([job_application.user.email])
        expect(mail.from).to eq(["hello@localhost"])
        expect(mail.reply_to.first).to match(/\+/)
        expect(mail.header["Message-ID"]).to be_nil
      end

      it "renders the body" do
        expect(mail.body.encoded).to match(/Vous recevez ce message parce que vous avez candidat/)
        expect(mail.body.encoded).to match(/vous pouvez répondre à cet email directement/)
      end
    end
  end

  describe "notify_new_state" do
    subject(:notify_new_state) { described_class.with(user:, job_offer:, state:).notify_new_state }

    let(:job_application) { build_stubbed(:job_application) }
    let(:user) { job_application.user }
    let(:job_offer) { job_application.job_offer }
    let(:state) { "phone_meeting" }

    it { expect(notify_new_state.subject).to eq("Votre candidature : nouvelle étape") }

    it { expect(notify_new_state.body.encoded).to match(/Votre candidature est passée à l'étape/) }
  end

  describe "notify_rejected" do
    subject(:notify_rejected) { described_class.with(user:, job_offer:).notify_rejected }

    let(:job_application) { build_stubbed(:job_application) }
    let(:user) { job_application.user }
    let(:job_offer) { job_application.job_offer }

    it { expect(notify_rejected.subject).to eq("Votre candidature a été refusée") }

    it { expect(notify_rejected.body.encoded).to match(/nous ne pouvons pas actuellement y donner une suite favorable/) }
  end
end
