require "rails_helper"

RSpec.describe ApplicationHelper do
  describe "#header_offers_active?" do
    subject { helper.header_offers_active?(controller_name, action_name, job_offer: job_offer) }

    context "when controller_name is job_offers and action_name is index" do
      let(:controller_name) { "job_offers" }
      let(:action_name) { "index" }
      let(:job_offer) { nil }

      it { is_expected.to be_truthy }
    end

    context "when controller_name is job_offers and action_name is show and job_offer is not spontaneous" do
      let(:controller_name) { "job_offers" }
      let(:action_name) { "show" }
      let(:job_offer) { instance_double(JobOffer, spontaneous?: false) }

      it { is_expected.to be_truthy }
    end

    context "when controller_name is job_offers and action_name is show and job_offer is spontaneous" do
      let(:controller_name) { "job_offers" }
      let(:action_name) { "show" }
      let(:job_offer) { instance_double(JobOffer, spontaneous?: true) }

      it { is_expected.to be_falsey }
    end

    context "when controller_name is not job_offers" do
      let(:controller_name) { "other" }
      let(:action_name) { "index" }
      let(:job_offer) { nil }

      it { is_expected.to be_falsey }
    end
  end

  describe "#header_spontaneous_active?" do
    subject { helper.header_spontaneous_active?(controller_name, action_name, job_offer: job_offer) }

    context "when controller_name is job_offers and action_name is show and job_offer is spontaneous" do
      let(:controller_name) { "job_offers" }
      let(:action_name) { "show" }
      let(:job_offer) { instance_double(JobOffer, spontaneous?: true) }

      it { is_expected.to be_truthy }
    end

    context "when controller_name is job_offers and action_name is show and job_offer is not spontaneous" do
      let(:controller_name) { "job_offers" }
      let(:action_name) { "show" }
      let(:job_offer) { instance_double(JobOffer, spontaneous?: false) }

      it { is_expected.to be_falsey }
    end

    context "when controller_name is not job_offers" do
      let(:controller_name) { "other" }
      let(:action_name) { "index" }
      let(:job_offer) { nil }

      it { is_expected.to be_falsey }
    end
  end
end
