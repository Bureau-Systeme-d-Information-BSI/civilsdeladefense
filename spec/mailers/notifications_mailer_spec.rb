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

  describe "employer_recruiter_daily_report" do
    subject(:mail) { described_class.with(administrator:).employer_recruiter_daily_report }

    let(:administrator) { create(:administrator, roles: %w[employer_recruiter]) }

    it "sets the subject with the service name" do
      expect(mail.subject).to eq(
        I18n.t(
          "notifications_mailer.employer_recruiter_daily_report.subject",
          service_name: administrator.organization.service_name
        )
      )
    end

    it { expect(mail.to).to match([administrator.email]) }

    it "renders one section per state plus the new offers section" do
      headings = mail.body.encoded.scan(%r{<h3>(.*?)</h3>}).flatten
      expect(headings.size).to eq(EmployerRecruiterDailyReport.new(administrator).sections.size)
    end

    it "renders the intro and outro" do
      body = mail.body.encoded
      expect(body).to include("Bonjour #{administrator.full_name},")
      expect(body).to include("Cordialement,")
      expect(body).to include(administrator.organization.service_name)
    end

    context "with a recently published offer the recruiter is actor on" do
      let(:job_offer) { create(:published_job_offer, published_at: 1.hour.ago) }

      before do
        create(:job_offer_actor, job_offer:, administrator:, role: :employer)
      end

      it "lists the offer in the mail body" do
        expect(mail.body.encoded).to include(job_offer.full_title)
      end
    end
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
end
