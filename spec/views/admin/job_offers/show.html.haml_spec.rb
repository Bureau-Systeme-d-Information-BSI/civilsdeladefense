require 'rails_helper'

RSpec.describe "admin/job_offers/show", type: :view do
  before(:each) do
    @job_offer = assign(:job_offer, create(:job_offer))
    @job_applications = assign(:job_applications, @job_offer.job_applications.group_by(&:state))
  end

  it "renders attributes in <p>" do
    render
    # expect(rendered).to match(/Title/)
    # expect(rendered).to match(/MyText/)
    # expect(rendered).to match(//)
    # expect(rendered).to match(//)
    # expect(rendered).to match(/Location/)
    # expect(rendered).to match(//)
    # expect(rendered).to match(/MyText/)
    # expect(rendered).to match(/MyText/)
    # expect(rendered).to match(//)
    # expect(rendered).to match(/false/)
    # expect(rendered).to match(//)
    # expect(rendered).to match(//)
    # expect(rendered).to match(//)
    # expect(rendered).to match(/false/)
    # expect(rendered).to match(/Estimate Monthly Salary Net/)
    # expect(rendered).to match(/Estimate Monthly Salary Gross/)
  end
end
