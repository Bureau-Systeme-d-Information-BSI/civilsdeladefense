# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'job_offers/show', type: :view do
  before(:each) do
    @job_offer = assign(:job_offer, create(:job_offer))
  end

  it 'renders attributes in <p>' do
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
