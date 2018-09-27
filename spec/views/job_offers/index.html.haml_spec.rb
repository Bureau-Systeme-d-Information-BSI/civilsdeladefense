require 'rails_helper'

RSpec.describe "job_offers/index", type: :view do
  before(:each) do
    categories = create_list(:category, 5)

    owner = create(:owner)
    category = categories.first
    official_status = create(:official_status)
    employer = create(:employer)
    contract_type = create(:contract_type)
    study_level = create(:study_level)
    experience_level = create(:experience_level)
    sector = create(:sector)

    job_offers = create_list(:job_offer,
      2,
      state: :published,
      owner: owner,
      category: category,
      official_status: official_status,
      employer: employer,
      contract_type: contract_type,
      study_level: study_level,
      experience_level: experience_level,
      sector: sector
    )

    assign(:categories, categories)
    assign(:job_offers, job_offers)
  end

  it "renders a list of job_offers" do
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
