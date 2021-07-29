require "rails_helper"

RSpec.describe Notification, type: :model do
  let(:job_application) { create(:job_application, state: :contract_drafting) }

  describe "job_application_contract_drafting_full" do
    before do
      create(
        :job_application_file_type,
        from_state: :contract_drafting, kind: :applicant_provided, by_default: true
      )
      create(
        :job_application_file_type,
        from_state: :contract_drafting, kind: :applicant_provided, by_default: true
      )
      create(
        :job_application_file_type,
        from_state: :contract_drafting, kind: :applicant_provided, by_default: false
      )
      create(
        :job_application_file_type,
        from_state: :contract_feedback_waiting, kind: :applicant_provided, by_default: true
      )
    end

    context "without all file" do
      before do
        job_application.files_to_be_provided
        file = job_application.job_application_files.first
        file.content = fixture_file_upload("document.pdf", "application/pdf")
        file.save
      end

      it "doesnt create Notification" do
        expect {
          Notification.job_application_contract_drafting_full(job_application)
        }.to change(JobApplication, :count).by(0)
      end
    end

    context "with all file" do
      before do
        job_application.files_to_be_provided
        job_application.job_application_files.each do |file|
          file.content = fixture_file_upload("document.pdf", "application/pdf")
          file.save
        end
      end

      it "doesnt create Notification" do
        expect {
          Notification.job_application_contract_drafting_full(job_application)
        }.to change(JobApplication, :count).by(0)
      end
    end

    context "with all file validated" do
      before do
        job_application.files_to_be_provided
        job_application.job_application_files.each do |file|
          file.content = fixture_file_upload("document.pdf", "application/pdf")
          file.save
          file.check!
        end
      end

      it "create Notification" do
        expect {
          Notification.job_application_contract_drafting_full(job_application)
        }.to change(Notification, :count)
      end
    end
  end
end

# == Schema Information
#
# Table name: notifications
#
#  id                 :uuid             not null, primary key
#  daily              :boolean          default(FALSE)
#  kind               :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  instigator_id      :uuid
#  job_application_id :uuid
#  job_offer_id       :uuid
#  recipient_id       :uuid             not null
#
# Indexes
#
#  index_notifications_on_instigator_id       (instigator_id)
#  index_notifications_on_job_application_id  (job_application_id)
#  index_notifications_on_job_offer_id        (job_offer_id)
#  index_notifications_on_recipient_id        (recipient_id)
#
# Foreign Keys
#
#  fk_rails_0595cf6733  (job_application_id => job_applications.id)
#  fk_rails_44e540a267  (instigator_id => administrators.id)
#  fk_rails_4aea6afa11  (recipient_id => administrators.id)
#  fk_rails_53ccaf6ba7  (job_offer_id => job_offers.id)
#
