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

    it { expect(mail.body.encoded).to match(/Vous êtes notifié comme/) }
  end
end
