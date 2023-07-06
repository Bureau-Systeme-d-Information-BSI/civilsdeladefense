# frozen_string_literal: true

require "rails_helper"

RSpec.describe Suspendable, type: :model do
  describe "#suspended" do
    subject { user.suspended? }

    let(:user) { build(:user, suspended_at: suspended_at) }

    context "when the user is suspended" do
      let(:suspended_at) { Time.zone.now }

      it { is_expected.to be(true) }
    end

    context "when the user is not suspended" do
      let(:suspended_at) { nil }

      it { is_expected.to be(false) }
    end
  end

  describe "#inactive_message" do
    subject { user.inactive_message }

    let(:user) { create(:confirmed_user, suspended_at: suspended_at) }

    context "when the user is suspended" do
      let(:suspended_at) { Time.zone.now }

      it { is_expected.to eq(:suspended) }
    end

    context "when the user is not suspended" do
      let(:suspended_at) { nil }

      it { is_expected.to eq(:inactive) }
    end
  end
end
