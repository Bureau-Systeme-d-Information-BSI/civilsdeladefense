# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'job_offers/index', type: :view do
  before(:each) do
    categories = create_list(:category, 5)
    contract_types = create_list(:contract_type, 2)

    owner = create(:owner)
    category = categories.first
    professional_category = create(:professional_category)
    employer = create(:employer)
    contract_type = contract_types.first
    study_level = create(:study_level)
    experience_level = create(:experience_level)
    sector = create(:sector)

    job_offers = create_list(:job_offer,
                             2,
                             state: :published,
                             owner: owner,
                             category: category,
                             professional_category: professional_category,
                             employer: employer,
                             contract_type: contract_type,
                             study_level: study_level,
                             experience_level: experience_level,
                             sector: sector)

    assign(:categories, categories)
    assign(:categories_for_select, categories)
    assign(:contract_types, contract_types)
    assign(:job_offers, job_offers)
  end

  it 'renders a list of job_offers' do
    render
    # assert_select "tr>td", :text => "Title".to_s, :count => 2
    # assert_select "tr>td", :text => "MyText".to_s, :count => 2
    # assert_select "tr>td", :text => nil.to_s, :count => 2
    # assert_select "tr>td", :text => nil.to_s, :count => 2
    # assert_select "tr>td", :text => "Location".to_s, :count => 2
    # assert_select "tr>td", :text => nil.to_s, :count => 2
    # assert_select "tr>td", :text => "MyText".to_s, :count => 2
    # assert_select "tr>td", :text => "MyText".to_s, :count => 2
    # assert_select "tr>td", :text => nil.to_s, :count => 2
    # assert_select "tr>td", :text => false.to_s, :count => 2
    # assert_select "tr>td", :text => nil.to_s, :count => 2
    # assert_select "tr>td", :text => nil.to_s, :count => 2
    # assert_select "tr>td", :text => nil.to_s, :count => 2
    # assert_select "tr>td", :text => false.to_s, :count => 2
    # assert_select "tr>td", :text => "Estimate Monthly Salary Net".to_s, :count => 2
    # assert_select "tr>td", :text => "Estimate Monthly Salary Gross".to_s, :count => 2
  end
end
