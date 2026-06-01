require "rails_helper"

RSpec.describe JobApplicationFile do
  describe "delegations" do
    it { is_expected.to delegate_method(:state).to(:job_application).with_prefix(true) }
  end

  describe "#record_by_user" do
    subject(:record_by_user) { job_application_file.record_by_user }

    let(:job_application_file) { build(:job_application_file, job_application:) }
    let(:job_application) { create(:job_application) }

    context "when the file is valid" do
      it { is_expected.to be(true) }

      it { expect { record_by_user }.to change { job_application.job_application_files.count }.by(1) }

      context "when the file type has notification recipients" do
        let(:job_application_file_type) { create(:job_application_file_type, notify_hr_manager: true) }
        let(:job_application_file) { build(:job_application_file, job_application:, job_application_file_type:) }
        let!(:hr_manager) { create(:administrator, roles: [:hr_manager]) }

        before { create(:job_offer_actor, job_offer: job_application.job_offer, administrator: hr_manager) }

        it { expect { record_by_user }.to have_enqueued_mail(NotificationsMailer, :new_document) }
      end

      context "when the file type has no notification recipients" do
        it { expect { record_by_user }.not_to have_enqueued_mail(NotificationsMailer, :new_document) }
      end
    end

    context "when the file is invalid" do
      before { job_application_file.content = nil }

      it { is_expected.to be(false) }

      it { expect { record_by_user }.not_to change { job_application.job_application_files.count } }
    end
  end

  describe "#downloadable?" do
    subject(:downloadable) { job_application_file.downloadable? }

    let(:job_application_file) { build(:job_application_file, job_application:, job_application_file_type:) }
    let(:job_application) { build(:job_application, state: current_state) }
    let(:job_application_file_type) { create(:job_application_file_type) }

    context "when the current state is before the max administrator visibility rule" do
      let(:current_state) { :initial }

      before { job_application_file_type.visibility_rules.create!(by: :administrator, state: :phone_meeting) }

      it { is_expected.to be(true) }
    end

    context "when the current state equals the max administrator visibility rule" do
      let(:current_state) { :initial }

      it { is_expected.to be(false) }
    end

    context "when the current state is after the max administrator visibility rule" do
      let(:current_state) { :phone_meeting }

      it { is_expected.to be(false) }
    end
  end

  describe "#unrequestable?" do
    subject(:unrequestable) { job_application_file.unrequestable? }

    let(:job_application_file) { build(:job_application_file, job_application_file_type:) }
    let(:job_application_file_type) { build(:job_application_file_type, required:) }

    context "when the file type is not required by default" do
      let(:required) { false }

      it { is_expected.to be(true) }
    end

    context "when the file type is required by default" do
      let(:required) { true }

      it { is_expected.to be(false) }
    end
  end
end

# == Schema Information
#
# Table name: job_application_files
#
#  id                               :uuid             not null, primary key
#  content_file_name                :string
#  encrypted_file_transfer_in_error :boolean          default(FALSE)
#  is_validated                     :integer          default(0)
#  secured_content_file_name        :string
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#  job_application_file_type_id     :uuid
#  job_application_id               :uuid
#
# Indexes
#
#  index_job_application_files_on_job_application_file_type_id  (job_application_file_type_id)
#  index_job_application_files_on_job_application_id            (job_application_id)
#
# Foreign Keys
#
#  fk_rails_334ab4b230  (job_application_file_type_id => job_application_file_types.id)
#  fk_rails_d6522ee61f  (job_application_id => job_applications.id)
#
