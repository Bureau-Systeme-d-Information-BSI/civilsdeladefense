require 'rails_helper'
require 'will_paginate/array'

RSpec.describe "admin/job_applications/index", type: :view do
  before(:each) do
    categories = create_list(:category, 5)
    employers = create_list(:employer, 2)
    contract_types = create_list(:contract_type, 2)
    job_offer = create(:job_offer, category: categories.sample, contract_type: contract_types.sample)
    job_applications = create_list(:job_application, 5, employer: employers.sample, job_offer: job_offer)

    assign(:employers, employers)
    assign(:contract_types, contract_types)
    assign(:job_applications, job_applications.paginate)
  end

  it "renders a list of admin/job_applications" do
    render
    # assert_select "tr>td", :text => nil.to_s, :count => 2
    # assert_select "tr>td", :text => nil.to_s, :count => 2
    # assert_select "tr>td", :text => "First Name".to_s, :count => 2
    # assert_select "tr>td", :text => "Last Name".to_s, :count => 2
    # assert_select "tr>td", :text => "Current Position".to_s, :count => 2
    # assert_select "tr>td", :text => "Phone".to_s, :count => 2
    # assert_select "tr>td", :text => "Address 1".to_s, :count => 2
    # assert_select "tr>td", :text => "Address 2".to_s, :count => 2
    # assert_select "tr>td", :text => "Postal Code".to_s, :count => 2
    # assert_select "tr>td", :text => "City".to_s, :count => 2
    # assert_select "tr>td", :text => "Country".to_s, :count => 2
    # assert_select "tr>td", :text => "Portfolio Url".to_s, :count => 2
    # assert_select "tr>td", :text => "Website Url".to_s, :count => 2
    # assert_select "tr>td", :text => "Linkedin Url".to_s, :count => 2
  end
end
