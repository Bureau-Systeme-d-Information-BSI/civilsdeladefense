# frozen_string_literal: true

require "rails_helper"

RSpec.describe Exporter::Users do
  let(:admin) { create(:administrator) }
  let(:job_application) { create(:job_application) }
  let(:candidate) { job_application.user }

  before do
    create(
      :profile_foreign_language,
      profile: candidate.profile,
      foreign_language: create(:foreign_language),
      foreign_language_level: create(:foreign_language_level)
    )
  end

  describe "#generate" do
    subject(:generate) { described_class.new([candidate], admin).generate }

    it { is_expected.to be_a(StringIO) }
  end

  describe "#format_job_application" do
    subject(:format_job_application) { described_class.new([candidate], admin).format_job_application(job_application, 0) }

    it { is_expected.to include(job_application.job_offer.employer.name) }
  end
end
