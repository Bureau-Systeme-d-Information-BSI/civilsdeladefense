# frozen_string_literal: true

require "rails_helper"

RSpec.describe JobOffersHelper do
  describe ".job_offer_contract_type_display" do
    subject { job_offer_contract_type_display(job_offer.reload) }

    let!(:job_offer) { create(:job_offer, :with_contract_duration) }

    it { is_expected.to eq("#{job_offer.contract_type_name} #{job_offer.contract_duration_name}") }

    context "when the job offer doesn't have a contract type" do
      before { job_offer.contract_type.destroy! }

      it { is_expected.to eq("") }
    end

    context "when the job offer doesn't have a contract duration" do
      before { job_offer.contract_duration.destroy! }

      it { is_expected.to eq(job_offer.contract_type_name) }
    end
  end

  describe ".job_offer_value_for_attribute" do
    subject { job_offer_value_for_attribute(job_offer, attribute) }

    let(:job_offer) { create(:job_offer) }

    context "when the attribute is :contract_type" do
      let(:attribute) { :contract_type }

      it { is_expected.to eq(job_offer_contract_type_display(job_offer)) }
    end

    context "when the attribute is :contract_start_on" do
      let(:attribute) { :contract_start_on }

      it { is_expected.to eq(I18n.l(job_offer.contract_start_on)) }
    end

    context "when the attribute is :location" do
      let(:attribute) { :location }

      it { is_expected.to eq(job_offer.location) }
    end

    context "when the attribute is :study_level" do
      let(:attribute) { :study_level }

      it { is_expected.to eq(job_offer.study_level.name) }

      context "when the job offer doesn't have a study level" do
        before do
          job_offer.study_level.destroy!
          job_offer.reload
        end

        it { is_expected.to eq("-") }
      end
    end

    context "when the attribute is :category" do
      let(:attribute) { :category }

      it { is_expected.to eq(job_offer.category.name) }

      context "when the job offer doesn't have a category" do
        before do
          job_offer.category.destroy!
          job_offer.reload
        end

        it { is_expected.to eq("-") }
      end
    end

    context "when the attribute is :experience_level" do
      let(:attribute) { :experience_level }

      it { is_expected.to eq(job_offer.experience_level.name) }

      context "when the job offer doesn't have an experience level" do
        before do
          job_offer.experience_level.destroy!
          job_offer.reload
        end

        it { is_expected.to eq("-") }
      end
    end

    context "when the attribute is :salary" do
      let(:attribute) { :salary }

      it { is_expected.to eq(job_offer_salary_display(job_offer)) }
    end

    context "when the attribute is :benefits" do
      let(:attribute) { :benefits }

      it { is_expected.to eq(job_offer_benefits_display(job_offer)) }
    end

    context "when the attribute is :drawbacks" do
      let(:attribute) { :drawbacks }

      it { is_expected.to eq(job_offer_drawbacks_display(job_offer)) }
    end

    context "when the attribute is :is_remote_possible" do
      let(:attribute) { :is_remote_possible }

      it { is_expected.to eq("Non") }
    end
  end

  describe ".job_offer_start_display" do
    subject { job_offer_start_display(job_offer) }

    let(:job_offer) { create(:job_offer) }

    it { is_expected.to eq(I18n.l(job_offer.contract_start_on)) }
  end
end
