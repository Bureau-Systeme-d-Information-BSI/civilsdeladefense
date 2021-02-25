# frozen_string_literal: true

require "rails_helper"

RSpec.describe DailySummary do
  it "sends valid summary with valid attributes" do
    ary = create_list :job_offer, 5
    ary[0].publish!

    ary2 = create_list(:job_application, 5, job_offer: ary[0])
    ary2[0].accepted!

    summary = DailySummary.new(day: Time.now)
    expect(summary.prepare(Organization.first)).to be true
  end
end
