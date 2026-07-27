require "rails_helper"

RSpec.describe NotificationsMailer do
  describe "new_email" do
    subject(:mail) { described_class.with(administrator:, job_application:).new_email }

    let(:administrator) { create(:administrator) }
    let(:job_application) { create(:job_application) }

    it {
      expect(mail.subject).to eq(
        I18n.t(
          "notifications_mailer.new_email.subject",
          service_name: administrator.organization.service_name,
          state: JobApplication.human_attribute_name("state/#{job_application.state}")
        )
      )
    }

    it { expect(mail.to).to match([administrator.email]) }

    it { expect(mail.body.encoded).to match(/a répondu à votre proposition d’entretien/) }
  end

  describe "contract_drafting" do
    subject(:mail) { described_class.with(administrator:, job_application:).contract_drafting }

    let(:administrator) { create(:administrator) }
    let(:job_application) { create(:job_application) }

    it {
      expect(mail.subject).to eq(
        I18n.t(
          "notifications_mailer.contract_drafting.subject",
          service_name: administrator.organization.service_name
        )
      )
    }

    it { expect(mail.to).to match([administrator.email]) }

    it { expect(mail.body.encoded).to match(/à l'étape Validation dossier complet/) }
  end

  describe "contract_feedback_waiting" do
    subject(:mail) { described_class.with(administrator:, job_application:).contract_feedback_waiting }

    let(:administrator) { create(:administrator) }
    let(:job_application) { create(:job_application) }

    it {
      expect(mail.subject).to eq(
        I18n.t(
          "notifications_mailer.contract_feedback_waiting.subject",
          service_name: administrator.organization.service_name
        )
      )
    }

    it { expect(mail.to).to match([administrator.email]) }

    it { expect(mail.body.encoded).to match(/à l'étape Contrat/) }
  end

  describe "contract_received" do
    subject(:mail) { described_class.with(administrator:, job_application:).contract_received }

    let(:administrator) { create(:administrator) }
    let(:job_application) { create(:job_application) }

    it {
      expect(mail.subject).to eq(
        I18n.t(
          "notifications_mailer.contract_received.subject",
          service_name: administrator.organization.service_name
        )
      )
    }

    it { expect(mail.to).to match([administrator.email]) }

    it { expect(mail.body.encoded).to match(/à l'étape Dossier de paie/) }
  end

  describe "affected" do
    subject(:mail) { described_class.with(administrator:, job_application:).affected }

    let(:administrator) { create(:administrator) }
    let(:job_application) { create(:job_application) }

    it {
      expect(mail.subject).to eq(
        I18n.t(
          "notifications_mailer.affected.subject",
          service_name: administrator.organization.service_name
        )
      )
    }

    it { expect(mail.to).to match([administrator.email]) }

    it { expect(mail.body.encoded).to match(/à l'étape Prise de poste/) }
  end

  describe "new_document" do
    subject(:mail) { described_class.with(administrator:, job_application:).new_document }

    let(:administrator) { create(:administrator) }
    let(:job_application) { create(:job_application) }

    it {
      expect(mail.subject).to eq(
        I18n.t(
          "notifications_mailer.new_document.subject",
          service_name: administrator.organization.service_name
        )
      )
    }

    it { expect(mail.to).to match([administrator.email]) }

    it { expect(mail.body.encoded).to match(/nouveau document à consulter/) }
  end

  describe "deletion_warning" do
    subject(:mail) { described_class.with(administrator:).deletion_warning }

    let(:administrator) { create(:administrator) }

    it {
      expect(mail.subject).to eq(
        I18n.t(
          "notifications_mailer.deletion_warning.subject",
          service_name: administrator.organization.service_name
        )
      )
    }

    it { expect(mail.to).to match([administrator.email]) }

    it { expect(mail.body.encoded).to match(/Sans connexion sous 30 jours, votre compte sera supprimé automatiquement/) }
  end

  describe "deletion_canceled" do
    subject(:mail) { described_class.with(administrator:).deletion_canceled }

    let(:administrator) { create(:administrator) }

    it {
      expect(mail.subject).to eq(
        I18n.t(
          "notifications_mailer.deletion_canceled.subject",
          service_name: administrator.organization.service_name
        )
      )
    }

    it { expect(mail.to).to match([administrator.email]) }

    it { expect(mail.body.encoded).to match(/votre compte utilisateur a bien été mis à jour/) }
  end

  describe "deletion_notice" do
    subject(:mail) do
      described_class.with(
        email: administrator.email,
        full_name: administrator.full_name,
        organization_id: administrator.organization_id
      ).deletion_notice
    end

    let(:administrator) { create(:administrator) }

    it {
      expect(mail.subject).to eq(
        I18n.t(
          "notifications_mailer.deletion_notice.subject",
          service_name: administrator.organization.service_name
        )
      )
    }

    it { expect(mail.to).to match([administrator.email]) }

    it { expect(mail.body.encoded).to match(/vous devrez créer un nouveau compte/) }
  end
end
