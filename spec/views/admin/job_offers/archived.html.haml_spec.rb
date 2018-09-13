require 'rails_helper'

RSpec.describe "admin/job_offers/archived", type: :view do
  before(:each) do
    owner = create(:owner)
    category = create(:category)
    official_status = create(:official_status)
    employer = create(:employer)
    contract_type = create(:contract_type)
    study_level = create(:study_level)
    experience_level = create(:experience_level)
    sector = create(:sector)

    ary1 = assign(:job_offers_active, [
      2.times do
        create(:job_offer,
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
      end
    ])
    ary2 = assign(:job_offers_archived, [
      3.times do
        create(:job_offer,
          state: :archived,
          owner: owner,
          category: category,
          official_status: official_status,
          employer: employer,
          contract_type: contract_type,
          study_level: study_level,
          experience_level: experience_level,
          sector: sector
        )
      end
    ])
    assign(:job_offers, ary2)
  end

  it "renders a list of job_offers" do
    render_template('/admin/job_offers/index')
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
