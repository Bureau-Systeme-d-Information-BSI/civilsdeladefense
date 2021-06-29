# frozen_string_literal: false

require "rails_helper"

RSpec.describe JobApplication, type: :model do
  let(:job_offer) { create(:job_offer) }
  let(:job_application) { create(:job_application, job_offer: job_offer) }

  it "should correcty tell rejected state" do
    expect(job_application.rejected_state?).to be(false)

    job_application.reject!
    expect(job_application.rejected_state?).to be(true)

    job_application.phone_meeting!
    expect(job_application.rejected_state?).to be(false)

    job_application.phone_meeting_rejected!
    expect(job_application.rejected_state?).to be(true)

    job_application.to_be_met!
    expect(job_application.rejected_state?).to be(false)

    job_application.after_meeting_rejected!
    expect(job_application.rejected_state?).to be(true)

    job_offer.update(published_at: 40.days.before)
    job_application.accepted!
    expect(job_application.rejected_state?).to be(false)

    job_application.contract_drafting!
    expect(job_application.rejected_state?).to be(false)

    job_application.contract_feedback_waiting!
    expect(job_application.rejected_state?).to be(false)

    job_application.contract_received!
    expect(job_application.rejected_state?).to be(false)

    job_application.affected!
    expect(job_application.rejected_state?).to be(false)
  end

  it "should correcty tell rejected states from JobOffer class" do
    ary = %w[rejected phone_meeting_rejected after_meeting_rejected]
    expect(JobApplication.rejected_states).to match_array(ary)
  end

  describe "files_to_be_provided" do
    before do
      JobApplicationFileType.create(
        name: "CV", from_state: :initial, kind: :applicant_provided, by_default: true
      )
      JobApplicationFileType.create(
        name: "LM", from_state: :initial, kind: :applicant_provided, by_default: true
      )
      JobApplicationFileType.create(
        name: "FILE", from_state: :to_be_met, kind: :applicant_provided, by_default: true
      )
    end

    it "should compute files to be provided" do
      ary1, ary2 = job_application.files_to_be_provided
      expect(ary1.size).to eq(2)
      expect(ary2.size).to eq(1)

      job_application.job_application_files.each do |file|
        file.content = fixture_file_upload("document.pdf", "application/pdf")
      end
      job_application.to_be_met!

      ary1, ary2 = job_application.files_to_be_provided
      expect(ary1.size).to eq(3)
      expect(ary2.size).to eq(0)
    end
  end

  describe "cant_accept_before_delay" do
    context "when job_offer published 20 days before" do
      before { job_offer.update(published_at: 20.days.before) }

      it "cant be accepted" do
        expect { job_application.accepted! }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context "when job_offer published 31 days before" do
      before { job_offer.update(published_at: 31.days.before) }

      it "can be accepted" do
        expect(job_application.accepted!).to be(true)
      end
    end
  end
end

# == Schema Information
#
# Table name: job_applications
#
#  id                                :uuid             not null, primary key
#  administrator_notifications_count :integer          default(0)
#  emails_administrator_unread_count :integer          default(0)
#  emails_count                      :integer          default(0)
#  emails_unread_count               :integer          default(0)
#  emails_user_unread_count          :integer          default(0)
#  experiences_fit_job_offer         :boolean
#  files_count                       :integer          default(0)
#  files_unread_count                :integer          default(0)
#  skills_fit_job_offer              :boolean
#  state                             :integer
#  created_at                        :datetime         not null
#  updated_at                        :datetime         not null
#  category_id                       :uuid
#  employer_id                       :uuid
#  job_offer_id                      :uuid
#  organization_id                   :uuid
#  rejection_reason_id               :uuid
#  user_id                           :uuid
#
# Indexes
#
#  index_job_applications_on_category_id          (category_id)
#  index_job_applications_on_employer_id          (employer_id)
#  index_job_applications_on_job_offer_id         (job_offer_id)
#  index_job_applications_on_organization_id      (organization_id)
#  index_job_applications_on_rejection_reason_id  (rejection_reason_id)
#  index_job_applications_on_state                (state)
#  index_job_applications_on_user_id              (user_id)
#
# Foreign Keys
#
#  fk_rails_0e9ee51b69  (user_id => users.id)
#  fk_rails_36c9b0d626  (category_id => categories.id)
#  fk_rails_88b000fe87  (job_offer_id => job_offers.id)
#  fk_rails_e668fb8ac4  (employer_id => employers.id)
#  fk_rails_e73e1d195a  (rejection_reason_id => rejection_reasons.id)
#
