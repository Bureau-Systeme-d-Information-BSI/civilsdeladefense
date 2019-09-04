# frozen_string_literal: true

require 'rails_helper'
require 'will_paginate/array'

RSpec.describe 'admin/job_applications/index', type: :view do
  before(:each) do
    categories = create_list(:category, 5)
    employers = create_list(:employer, 2)
    job_offer = create(:job_offer,
                       category: categories.sample)
    job_applications = create_list(:job_application,
                                   5,
                                   employer: employers.sample,
                                   job_offer: job_offer)

    assign(:employers, employers)
    assign(:contract_types, contract_types)
    job_applications_ary = assign(:job_applications, job_applications)

    assign(:q, JobApplication.ransack)
    collection = WillPaginate::Collection.new(4, 10, 0)
    job_applications_ary.each do |elt|
      collection << elt
    end
    assign(:job_applications_filtered, collection)
  end

  it 'renders a list of admin/job_applications' do
    render
  end
end
