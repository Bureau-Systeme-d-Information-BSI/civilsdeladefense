# frozen_string_literal: true

require "rails_helper"

RSpec.describe PdfJobOffer do
  describe "#filename" do
    subject { described_class.new(job_offer).filename }

    let(:job_offer) { build(:job_offer, title: "Job Offer Title") }

    it { is_expected.to eq("job-offer-title.pdf") }
  end

  describe "#render" do
    subject { described_class.new(job_offer).render }

    let(:job_offer) { build(:job_offer) }

    it { is_expected.to include("PDF-1.3") }
  end
end
