# frozen_string_literal: true

require "rails_helper"

RSpec.describe ForbiddenState do
  let(:data) { {state: "unknown_state"} }

  describe "#data" do
    subject(:error_data) { described_class.new(data).data }

    it { is_expected.to eq(data) }
  end

  describe "#message" do
    subject(:message) { described_class.new(data).message }

    it { is_expected.to eq(data.to_s) }
  end

  describe "#error_message" do
    subject(:error_message) { described_class.new(data).error_message }

    it { is_expected.to eq("State unknown_state is not a known state") }
  end
end
