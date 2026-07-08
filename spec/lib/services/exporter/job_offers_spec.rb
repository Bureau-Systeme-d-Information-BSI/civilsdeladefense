# frozen_string_literal: true

require "rails_helper"

RSpec.describe Exporter::JobOffers do
  let(:job_offer) { create(:job_offer) }
  let(:user) { create(:administrator) }

  describe "#generate" do
    subject(:generate) { described_class.new([job_offer], user).generate }

    it { is_expected.to be_a(StringIO) }
  end

  describe "#format_job_offer" do
    subject(:format_job_offer) { described_class.new([job_offer], user).format_job_offer(job_offer) }

    it { is_expected.to include(job_offer.title) }
  end
end
