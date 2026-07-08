# frozen_string_literal: true

require "rails_helper"

RSpec.describe JobOfferNotAvailableAnymore do
  let(:data) { {job_offer_title: "Developer"} }

  describe "#data" do
    subject(:error_data) { described_class.new(data).data }

    it { is_expected.to eq(data) }
  end

  describe "#message" do
    subject(:message) { described_class.new(data).message }

    it { is_expected.to eq(data.to_s) }
  end
end
