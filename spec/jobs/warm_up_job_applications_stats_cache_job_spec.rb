# frozen_string_literal: true

require "rails_helper"

RSpec.describe WarmUpJobApplicationsStatsCacheJob, type: :job do
  it "warms up the job application state durations map cache" do
    allow(JobApplication).to receive(:cache_state_durations_map)
    start_date = 1.month.ago
    end_date = 1.day.ago
    scope = JobApplication
      .where(created_at: start_date..end_date)
      .ransack(start: start_date, end: end_date)
      .result(distinct: true)
      .unscope(:order)

    described_class.new.perform(start_date: start_date, end_date: end_date)
    expect(JobApplication).to have_received(:cache_state_durations_map).with(scope)
  end
end
