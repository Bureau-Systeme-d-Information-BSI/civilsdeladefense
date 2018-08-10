require 'rails_helper'

RSpec.describe "admin/job_applications/index", type: :view do
  before(:each) do
    assign(:job_applications, [
      create(:job_application),
      create(:job_application)
    ])
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
