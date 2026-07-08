# frozen_string_literal: true

require "rails_helper"

RSpec.describe NamingHelper do
  before do
    without_partial_double_verification do
      allow(helper).to receive(:current_organization).and_return(organization)
    end
  end

  let(:organization) do
    Organization.new(
      privacy_policy_url: "https://example.test/privacy",
      service_name: "MonService",
      prefix_article: "le",
      operator_name: "Operator SA",
      brand_name: "MaMarque"
    )
  end

  describe "#tos_acceptance_text" do
    subject(:tos_acceptance_text) { helper.tos_acceptance_text }

    it { is_expected.to be_html_safe }

    it { is_expected.to include(%(<span style="display: inline;">)) }

    it { is_expected.to include("MonService") }
  end

  describe "#footer_social_intro" do
    subject(:footer_social_intro) { helper.footer_social_intro }

    context "when the organization has an operator name" do
      it { is_expected.to eq("Les réseaux sociaux du Operator SA") }
    end

    context "when the organization has no operator name" do
      before { organization.operator_name = nil }

      it { is_expected.to eq("Les réseaux sociaux du MaMarque") }
    end
  end

  describe "#copyright" do
    subject(:copyright) { helper.copyright }

    it { is_expected.to eq("© Operator SA #{Time.zone.now.year}") }
  end
end
