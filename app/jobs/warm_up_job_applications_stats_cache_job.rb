# frozen_string_literal: true

class WarmUpJobApplicationsStatsCacheJob < ApplicationJob
  queue_as :default

  def perform(start_date:, end_date:)
    JobApplication.cache_state_durations_map(
      JobApplication
        .where(created_at: start_date..end_date)
        .ransack(start: start_date, end: end_date)
        .result(distinct: true)
        .unscope(:order)
    )
  end
end
