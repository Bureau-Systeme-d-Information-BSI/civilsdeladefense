# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'admin/job_offers/archived', type: :view do
  before(:each) do
    owner = create(:owner)
    category = create(:category)
    employer = create(:employer)

    ary = create_list(:job_offer,
                      2,
                      state: :published,
                      owner: owner,
                      category: category,
                      employer: employer)
    assign(:job_offers_active, ary)
    ary = create_list(:job_offer,
                      3,
                      state: :archived,
                      owner: owner,
                      category: category,
                      employer: employer)
    ary2 = assign(:job_offers_archived, ary)
    assign(:job_offers, ary2)
  end

  it 'renders a list of job_offers' do
    render_template('/admin/job_offers/index')
  end
end
