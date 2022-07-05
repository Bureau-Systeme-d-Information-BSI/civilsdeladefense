# frozen_string_literal: true

require "rails_helper"
require "will_paginate/array"

RSpec.describe "job_offers/index", type: :view do
  before do
    categories = create_list(:category, 5)
    job_offers = create_list(:job_offer, 30)

    assign(:categories, categories)
    assign(:contract_types, contract_types)
    assign(:job_offers, job_offers.paginate(page: nil))
    assign(:study_levels, study_levels)
    assign(:experience_levels, experience_levels)
    assign(:regions, job_offers.pluck(:region))
  end

  it "renders a list of job_offers" do
    render
  end
end
