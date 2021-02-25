# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/job_offers/index", type: :view do
  login_admin

  before(:each) do
    employers = create_list(:employer, 5)

    owner = create(:owner)
    category = create(:category)
    employer = employers.first

    ary1 = assign(:job_offers_active, create_list(:job_offer,
      2,
      state: :published,
      owner: owner,
      category: category,
      employer: employer))
    assign(:job_offers_archived, create_list(:job_offer,
      3,
      state: :archived,
      owner: owner,
      category: category,
      employer: employer))
    assign(:job_offers_unfiltered, JobOffer.all)
    assign(:q, JobOffer.ransack)
    collection = WillPaginate::Collection.new(4, 10, 0)
    ary1.each do |elt|
      collection << elt
    end
    assign(:job_offers_filtered, collection)
    assign(:employers, employers)
  end

  it "renders a list of job_offers" do
    render
  end
end
