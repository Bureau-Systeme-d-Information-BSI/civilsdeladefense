# frozen_string_literal: true

require "rails_helper"

RSpec.describe RejectionReason, type: :model do
  it { should validate_presence_of(:name) }

  it "should cleanup rejection reason" do
    job_application = create(:job_application)
    expect(job_application.rejection_reason).to be nil

    job_application.rejected!
    job_application.update rejection_reason_id: described_class.all.sample.id
    expect(job_application.rejection_reason).not_to be nil

    job_application.accepted!
    expect(job_application.rejection_reason).to be nil

    job_application.phone_meeting_rejected!
    job_application.update rejection_reason_id: described_class.all.sample.id
    expect(job_application.rejection_reason).not_to be nil
  end
end

# == Schema Information
#
# Table name: rejection_reasons
#
#  id         :uuid             not null, primary key
#  name       :string
#  position   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_rejection_reasons_on_position  (position)
#
