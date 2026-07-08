# frozen_string_literal: true

require "rails_helper"

RSpec.describe JobApplicationsHelper do
  describe "#badge_color_for_state" do
    subject(:badge_color_for_state) { helper.badge_color_for_state(state) }

    context "when the state is start" do
      let(:state) { :start }

      it { is_expected.to eq("light invisible") }
    end

    context "when the state is initial" do
      let(:state) { :initial }

      it { is_expected.to eq("purple") }
    end

    context "when the state is draft" do
      let(:state) { :draft }

      it { is_expected.to eq("light-gray") }
    end

    context "when the state is accepted" do
      let(:state) { :accepted }

      it { is_expected.to eq("success") }
    end

    context "when the state is contract_drafting" do
      let(:state) { :contract_drafting }

      it { is_expected.to eq("primary") }
    end

    context "when the state is phone_meeting" do
      let(:state) { :phone_meeting }

      it { is_expected.to eq("info") }
    end

    context "when the state is unknown" do
      let(:state) { :unknown }

      it { is_expected.to be_nil }
    end
  end

  describe "#badge_class" do
    subject(:badge_class) { helper.badge_class(:initial) }

    it { is_expected.to eq("badge-purple") }
  end
end
