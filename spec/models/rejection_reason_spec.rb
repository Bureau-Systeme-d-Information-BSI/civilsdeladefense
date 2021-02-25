# frozen_string_literal: true

require "rails_helper"

RSpec.describe RejectionReason, type: :model do
  it { should validate_presence_of(:name) }

  it "should cleanup rejection reason" do
    @job_application = create(:job_application)
    expect(@job_application.rejection_reason).to be nil

    @job_application.rejected!
    @job_application.update_attribute :rejection_reason_id, RejectionReason.all.sample.id
    expect(@job_application.rejection_reason).not_to be nil

    @job_application.accepted!
    expect(@job_application.rejection_reason).to be nil
  end
end
