# frozen_string_literal: true

require "rails_helper"

RSpec.describe Email do
  it { is_expected.to validate_presence_of(:subject) }
  it { is_expected.to validate_presence_of(:body) }

  describe "#send_from_user" do
    subject(:send_from_user) { email.send_from_user }

    context "when the email can't be saved" do
      let(:email) { described_class.new }

      it { is_expected.to be(false) }
    end

    context "when the email can be saved" do
      shared_examples "an employer recruiter notification mailer" do
        before do
          create(:job_offer_actor, job_offer:, administrator:, role: :employer)
          allow(NotificationsMailer).to receive_messages(
            with: NotificationsMailer,
            new_email: mailer_double
          )
          send_from_user
        end

        it { expect(NotificationsMailer).to have_received(:with).with(administrator:, job_application:) }

        it { expect(NotificationsMailer).to have_received(:new_email) }
      end

      shared_examples "not a notification mailer" do
        before do
          allow(NotificationsMailer).to receive(:with)
          send_from_user
        end

        it { expect(NotificationsMailer).not_to have_received(:with) }
      end

      context "when the job application has phone_meeting state and at least one employer recruiter" do
        let(:job_application) { create(:job_application, job_offer:, state: :phone_meeting) }
        let(:administrator) { create(:administrator, roles: [:employer_recruiter]) }
        let(:job_offer) { create(:job_offer) }
        let(:email) { build(:email, job_application:) }
        let(:mailer_double) { instance_double(ActionMailer::MessageDelivery, deliver_later: true) }

        it { is_expected.to be(true) }

        it_behaves_like "an employer recruiter notification mailer"
      end

      context "when the job application has phone_meeting state and no employer recruiter" do
        let(:job_application) { create(:job_application, state: :phone_meeting) }
        let(:email) { build(:email, job_application:) }

        it { is_expected.to be(true) }

        it_behaves_like "not a notification mailer"
      end

      context "when the job application has to_be_met state and at least one employer recruiter" do
        let(:job_application) { create(:job_application, job_offer:, state: :to_be_met) }
        let(:administrator) { create(:administrator, roles: [:employer_recruiter]) }
        let(:job_offer) { create(:job_offer) }
        let(:email) { build(:email, job_application:) }
        let(:mailer_double) { instance_double(ActionMailer::MessageDelivery, deliver_later: true) }

        it { is_expected.to be(true) }

        it_behaves_like "an employer recruiter notification mailer"
      end

      context "when the job application has to_be_met state and no employer recruiter" do
        let(:job_application) { create(:job_application, state: :to_be_met) }
        let(:email) { build(:email, job_application:) }

        it { is_expected.to be(true) }

        it_behaves_like "not a notification mailer"
      end

      context "when the job application has another state even with at least one employer recruiter" do
        let(:job_application) { create(:job_application, job_offer:, state: :initial) }
        let(:administrator) { create(:administrator, roles: [:employer_recruiter]) }
        let(:job_offer) { create(:job_offer) }
        let(:email) { build(:email, job_application:) }
        let(:mailer_double) { instance_double(ActionMailer::MessageDelivery, deliver_later: true) }

        it { is_expected.to be(true) }

        it_behaves_like "not a notification mailer"
      end
    end
  end

  describe "#mark_as_read!" do
    it "marks the email as read" do
      email = create(:email, is_unread: true)
      expect { email.mark_as_read! }.to change { email.reload.is_unread }.from(true).to(false)
    end
  end

  describe "#mark_as_unread!" do
    it "marks the email as unread" do
      email = create(:email, is_unread: false)
      expect { email.mark_as_unread! }.to change { email.reload.is_unread }.from(false).to(true)
    end
  end
end

# == Schema Information
#
# Table name: emails
#
#  id                 :uuid             not null, primary key
#  body               :text
#  is_unread          :boolean          default(TRUE)
#  sender_type        :string
#  subject            :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  job_application_id :uuid
#  sender_id          :uuid
#
# Indexes
#
#  index_emails_on_job_application_id         (job_application_id)
#  index_emails_on_sender_type_and_sender_id  (sender_type,sender_id)
#
# Foreign Keys
#
#  fk_rails_ebb3716bca  (job_application_id => job_applications.id)
#
