# frozen_string_literal: true

require "rails_helper"

RSpec.describe DailySummary do
  let(:job_offers) { create_list(:published_job_offer, 5) }
  let(:job_offer) { job_offers.first }
  let(:job_applications) { create_list(:job_application, 5, job_offer: job_offer) }
  let(:job_application) { job_applications.first }
  let(:summary) { described_class.new(day: Time.zone.now) }

  before { job_application.accepted! }

  it "sends valid summary with valid attributes" do
    expect(summary.prepare(Organization.first)).to be true
  end
end
