# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::JobOffersHelper do
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
