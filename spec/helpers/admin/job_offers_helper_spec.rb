# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::JobOffersHelper do
  describe "#archived_listing?" do
    subject(:archived_listing?) { helper.archived_listing? }

    context "when the current controller lists archived job offers" do
      before { allow(helper).to receive(:controller).and_return(Admin::JobOffers::ArchivedController.new) }

      it { is_expected.to be(true) }
    end

    context "when the current controller is another one" do
      before { allow(helper).to receive(:controller).and_return(Admin::JobOffersController.new) }

      it { is_expected.to be(false) }
    end
  end

  describe "#featured_listing?" do
    subject(:featured_listing?) { helper.featured_listing? }

    context "when the current controller lists featured job offers" do
      before { allow(helper).to receive(:controller).and_return(Admin::JobOffers::FeaturedController.new) }

      it { is_expected.to be(true) }
    end

    context "when the current controller is another one" do
      before { allow(helper).to receive(:controller).and_return(Admin::JobOffersController.new) }

      it { is_expected.to be(false) }
    end
  end

  describe "#charts_per_day_options" do
    subject(:charts_per_day_options) { helper.charts_per_day_options }

    let(:expected) do
      {
        height: "200px",
        library: {
          tooltip: {crosshairs: true},
          legend: {enabled: false},
          xAxis: {type: "datetime"},
          yAxis: {allowDecimals: false}
        }
      }
    end

    it { is_expected.to eq(expected) }
  end
end
