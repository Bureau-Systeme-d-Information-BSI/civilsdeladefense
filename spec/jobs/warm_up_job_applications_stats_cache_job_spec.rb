# frozen_string_literal: true

require "rails_helper"

RSpec.describe WarmUpJobApplicationsStatsCacheJob, type: :job do
  let(:memory_store) { ActiveSupport::Cache.lookup_store(:memory_store) }
  let(:cache) { Rails.cache }

  before do
    allow(Rails).to receive(:cache).and_return(memory_store)
    Rails.cache.clear
  end

  it "warms up the job application state durations map cache" do
    start_date = 1.month.ago
    end_date = 1.day.ago
    scope = JobApplication
      .where(created_at: start_date..end_date)
      .ransack(start: start_date, end: end_date)
      .result(distinct: true)
      .unscope(:order)
    cache_key = scope.to_sql

    expect {
      described_class.new.perform(start_date: start_date, end_date: end_date)
    }.to change { Rails.cache.read(cache_key) }.from(nil).to(JobApplication.query_state_durations_map(scope))
  end
end
