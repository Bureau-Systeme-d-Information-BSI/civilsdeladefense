# frozen_string_literal: true

class WarmUpJobApplicationsStatsCacheJob < ApplicationJob
  queue_as :default

  def perform(start_date:, end_date:)
    scope = JobApplication
      .where(created_at: start_date..end_date)
      .ransack(start: start_date, end: end_date)
      .result(distinct: true)
      .unscope(:order)
    results = JobApplication.query_state_durations_map(scope)
    Rails.cache.write(scope.to_sql, results, expires_in: 24.hours)
  end
end
