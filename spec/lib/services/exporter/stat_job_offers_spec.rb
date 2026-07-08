# frozen_string_literal: true

require "rails_helper"

RSpec.describe Exporter::StatJobOffers do
  let(:user) { create(:administrator) }

  describe "#generate" do
    subject(:generate) { described_class.new(data, user).generate }

    let(:data) do
      employer = create(:employer)
      category = create(:category)
      bop = create(:bop)
      {
        job_offers_count: 5,
        date_start: Date.new(2026, 1, 1),
        date_end: Date.new(2026, 6, 1),
        job_offer_published: 3,
        job_offer_unfilled: 2,
        job_offer_filled: 1,
        profiles: 10,
        profile_availables: 7,
        average_affection: 12,
        q: {
          employer_id_in: [employer.id],
          job_offer_category_id_in: [category.id],
          contract_type_id_in: [ContractType.first.id],
          job_offer_bop_id_in: [bop.id],
          county_in: %w[35 75]
        }
      }
    end

    it { is_expected.to be_a(StringIO) }
  end
end
