# frozen_string_literal: true

require "rails_helper"

RSpec.describe Exporter::JobOffer do
  let(:job_offer) { create(:job_offer) }
  let(:user) { create(:administrator) }
  let(:stats) do
    {
      job_applications_count: 1,
      per_gender: {},
      per_age_range: {},
      per_experiences_fit_job_offer: {},
      per_has_corporate_experience: {},
      per_is_currently_employed: {},
      per_state: {},
      in_department_count: 0,
      per_rejection_reason: {},
      rejection_reasons: [],
      age_ranges: []
    }
  end

  describe "#generate" do
    subject(:generate) { described_class.new({stats:, job_offer:}, user).generate }

    it { is_expected.to be_a(StringIO) }
  end

  describe "#format_job_offer" do
    subject(:format_job_offer) { described_class.new({stats:, job_offer:}, user).format_job_offer }

    it { is_expected.to include(job_offer.title) }
  end

  describe "#format_job_application" do
    subject(:format_job_application) {
      described_class.new({stats:, job_offer:}, user).format_job_application(job_application)
    }

    let(:job_application) { create(:job_application, job_offer:) }

    it { is_expected.to include(job_application.user.first_name) }
  end

  describe "#job_offer" do
    subject(:job_offer_accessor) { described_class.new({stats:, job_offer:}, user).job_offer }

    it { is_expected.to eq(job_offer) }
  end

  describe "#stat_data" do
    subject(:stat_data) { described_class.new({stats:, job_offer:}, user).stat_data }

    it { is_expected.to eq(stats) }
  end
end
