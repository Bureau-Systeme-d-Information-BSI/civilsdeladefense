# frozen_string_literal: true

require "rails_helper"

RSpec.describe DailySummary do
  let(:job_offers) { create_list(:published_job_offer, 5) }
  let(:job_offer) { job_offers.first }
  let(:job_applications) { create_list(:job_application, 4, job_offer: job_offer) }
  let(:job_application) { create(:job_application, job_offer: job_offer, state: :accepted) }
  let(:summary) { described_class.new(day: Time.zone.now) }

  it { expect(summary.prepare(Organization.first)).to be_truthy }
end
