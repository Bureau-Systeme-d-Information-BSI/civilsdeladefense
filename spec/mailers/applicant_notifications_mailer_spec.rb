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

    context "when the email carries attachments" do
      before { create(:email_attachment, email: email) }

      it { expect(mail.attachments.map(&:filename)).to include("document.pdf") }
    end
  end

  describe "notify_new_state" do
    subject(:notify_new_state) { described_class.with(user:, job_offer:, state:).notify_new_state }

    let(:job_application) { build_stubbed(:job_application) }
    let(:user) { job_application.user }
    let(:job_offer) { job_application.job_offer }
    let(:state) { "phone_meeting" }

    it { expect(notify_new_state.subject).to include("Votre candidature") }

    it { expect(notify_new_state.body.encoded).to match(/Votre candidature est passée à l'étape/) }
  end

  describe "notify_new_documents" do
    subject(:mail) { described_class.with(user:, job_offer:, document_names:).notify_new_documents }

    let(:job_application) { build_stubbed(:job_application) }
    let(:user) { job_application.user }
    let(:job_offer) { job_application.job_offer }
    let(:document_names) { ["CV", "Lettre de motivation"] }

    it {
      expect(mail.subject).to eq(
        "Votre candidature à l'offre #{job_offer.title} sur #{job_offer.organization.service_name} – Nouveaux documents à consulter"
      )
    }

    it { expect(mail.to).to match([user.email]) }

    it { expect(mail.body.encoded).to match(/nouveaux documents à consulter/) }

    it { expect(mail.body.encoded).to match(/CV/) }

    it { expect(mail.body.encoded).to match(/Lettre de motivation/) }
  end

  describe "notify_rejected" do
    subject(:notify_rejected) { described_class.with(user:, job_offer:).notify_rejected }

    let(:job_application) { build_stubbed(:job_application) }
    let(:user) { job_application.user }
    let(:job_offer) { job_application.job_offer }

    it {
      expect(notify_rejected.subject).to eq(
        "Votre candidature à l'offre #{job_offer.title} sur #{job_offer.organization.service_name}"
      )
    }

    it { expect(notify_rejected.body.encoded).to match(/nous ne pouvons pas actuellement y donner une suite favorable/) }
  end

  describe "notify_withdrawn" do
    subject(:notify_withdrawn) { described_class.with(user:, job_offer:).notify_withdrawn }

    let(:job_application) { build_stubbed(:job_application) }
    let(:user) { job_application.user }
    let(:job_offer) { job_application.job_offer }

    it {
      expect(notify_withdrawn.subject).to eq(
        "Votre candidature à l'offre #{job_offer.title} sur #{job_offer.organization.service_name} – Confirmation de votre désistement"
      )
    }

    it { expect(notify_withdrawn.to).to match([user.email]) }

    it { expect(notify_withdrawn.body.encoded).to match(/Le désistement suite à votre candidature/) }
  end

  describe "send_job_offer" do
    subject(:send_job_offer) { described_class.send_job_offer(user, job_offer) }

    let(:job_offer) { create(:job_offer) }

    context "when the user accepts job offer mails" do
      let(:user) { create(:user, receive_job_offer_mails: true) }

      it { expect(send_job_offer.subject).to eq("Nouvelle offre") }

      it { expect(send_job_offer.to).to eq([user.email]) }

      it { expect(send_job_offer.body.encoded).to match(/Voici une nouvelle super offre/) }
    end

    context "when the user refuses job offer mails" do
      let(:user) { create(:user, receive_job_offer_mails: false) }

      it { expect(send_job_offer.message).to be_a(ActionMailer::Base::NullMail) }
    end
  end

  describe "error_email" do
    subject(:error_email) { described_class.error_email(user.email, "Sujet original") }

    let(:user) { create(:user) }

    it { expect(error_email.subject).to eq("[#{Organization.first.service_name}]") }

    it { expect(error_email.to).to eq([user.email]) }

    it { expect(error_email.body.encoded).to match(/Sujet original/) }
  end

  describe "notice_period_before_deletion" do
    subject(:notice_period_before_deletion) { described_class.notice_period_before_deletion(user.id) }

    let(:user) { create(:user) }

    it {
      expect(notice_period_before_deletion.subject).to eq(
        "[#{user.organization.service_name}] Votre compte candidat : mise à jour nécessaire"
      )
    }

    it { expect(notice_period_before_deletion.to).to eq([user.email]) }

    it { expect(notice_period_before_deletion.body.encoded).to match(/sera supprimé automatiquement/) }
  end

  describe "deletion_notice" do
    subject(:deletion_notice) { described_class.deletion_notice(user_email, "Jane Doe", organization.id) }

    let(:organization) { Organization.first }
    let(:user_email) { "candidat@example.com" }

    it {
      expect(deletion_notice.subject).to eq(
        "[#{organization.service_name}] Votre compte candidat a été supprimé"
      )
    }

    it { expect(deletion_notice.to).to eq([user_email]) }

    it { expect(deletion_notice.body.encoded).to match(/suppression de votre compte candidat/) }
  end
end
