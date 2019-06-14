# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'admin/job_offers/index', type: :view do
  login_admin

  before(:each) do
    employers = create_list(:employer, 5)

    owner = create(:owner)
    category = create(:category)
    professional_category = create(:professional_category)
    employer = employers.first
    contract_type = create(:contract_type)
    study_level = create(:study_level)
    experience_level = create(:experience_level)
    sector = create(:sector)

    ary1 = assign(:job_offers_active, create_list(:job_offer,
                                                  2,
                                                  state: :published,
                                                  owner: owner,
                                                  category: category,
                                                  professional_category: professional_category,
                                                  employer: employer,
                                                  contract_type: contract_type,
                                                  study_level: study_level,
                                                  experience_level: experience_level,
                                                  sector: sector))
    assign(:job_offers_archived, create_list(:job_offer,
                                             3,
                                             state: :archived,
                                             owner: owner,
                                             category: category,
                                             professional_category: professional_category,
                                             employer: employer,
                                             contract_type: contract_type,
                                             study_level: study_level,
                                             experience_level: experience_level,
                                             sector: sector))
    assign(:job_offers, ary1)
    assign(:q, JobOffer.ransack)
    collection = WillPaginate::Collection.new(4, 10, 0)
    ary1.each do |elt|
      collection << elt
    end
    assign(:current_job_offers, collection)
    assign(:employers, employers)
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
