# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'admin/job_offers/edit', type: :view do
  login_admin

  before(:each) do
    @job_offer = assign(:job_offer, create(:job_offer))
  end

  it 'renders the edit job_offer form' do
    render

    # assert_select "form[action=?][method=?]", job_offer_path(@job_offer), "post" do

    #   assert_select "input[name=?]", "job_offer[title]"

    #   assert_select "textarea[name=?]", "job_offer[description]"

    #   assert_select "input[name=?]", "job_offer[category_id]"

    #   assert_select "input[name=?]", "job_offer[professional_category_id]"

    #   assert_select "input[name=?]", "job_offer[location]"

    #   assert_select "input[name=?]", "job_offer[employer_id]"

    #   assert_select "textarea[name=?]", "job_offer[required_profile]"

    #   assert_select "textarea[name=?]", "job_offer[recruitment_process]"

    #   assert_select "input[name=?]", "job_offer[contract_type_id]"

    #   assert_select "input[name=?]", "job_offer[is_remote_possible]"

    #   assert_select "input[name=?]", "job_offer[study_level_id]"

    #   assert_select "input[name=?]", "job_offer[experience_level_id]"

    #   assert_select "input[name=?]", "job_offer[sector_id]"

    #   assert_select "input[name=?]", "job_offer[estimate_monthly_salary_net]"

    #   assert_select "input[name=?]", "job_offer[estimate_annual_salary_gross]"
    # end
  end
end
