# frozen_string_literal: true

require "rails_helper"

Rails.application.load_tasks

RSpec.describe :rebuild_job_offer_timestamp do
  let(:job_offer) { create(:job_offer) }

  it "should correctly rebuild timestamp from audit log" do
    job_offer.publish!
    published_at = job_offer.published_at
    expect(published_at).not_to be_nil
    job_offer.archive!
    archived_at = job_offer.archived_at
    expect(archived_at).not_to be_nil

    job_offer.update_columns(archived_at: nil, published_at: nil)

    run_task
    job_offer.reload
    expect(job_offer.published_at).not_to be_nil
    time_diff = (published_at - job_offer.published_at).abs
    expect(time_diff).to be_within(1.0).of(1.0)

    run_task
    job_offer.reload
    expect(job_offer.archived_at).not_to be_nil
    time_diff = (published_at - job_offer.published_at).abs
    expect(time_diff).to be_within(1.0).of(1.0)
  end

  def run_task
    Rake::Task["migrate_data:rebuild_job_offer_timestamp"].invoke
  end
end
