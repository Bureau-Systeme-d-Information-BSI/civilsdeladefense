# frozen_string_literal: true

require "rails_helper"

RSpec.describe JobOffersHelper do
  describe ".job_offer_contract_type_display" do
    subject { job_offer_contract_type_display(job_offer.reload) }

    let!(:job_offer) { create(:job_offer) }

    context "when the job offer has a contract type" do
      it { is_expected.to eq("CDI duration") }
    end

    context "when the job offer doesn't have a contract type" do
      before { ContractType.find_by(name: "CDI").destroy! }

      it { is_expected.to eq("duration") }
    end
  end
end
