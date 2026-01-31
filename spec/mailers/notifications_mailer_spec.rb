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

    it { expect(mail.body.encoded).to match(/à l'étape validation dossier complet/) }
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

    it { expect(mail.body.encoded).to match(/à l'étape contrat/) }
  end
end
