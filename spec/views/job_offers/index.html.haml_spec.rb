# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'job_offers/index', type: :view do
  before(:each) do
    categories = create_list(:category, 5)

    owner = create(:owner)
    category = categories.first
    employer = create(:employer)

    job_offers = create_list(:job_offer,
                             2,
                             state: :published,
                             owner: owner,
                             category: category,
                             employer: employer)

    assign(:categories, categories)
    assign(:categories_for_select, categories)
    assign(:contract_types, contract_types)
    assign(:job_offers, job_offers)
  end

  it 'renders a list of job_offers' do
    allow(view).to receive_messages(will_paginate: nil)

    render
  end
end
