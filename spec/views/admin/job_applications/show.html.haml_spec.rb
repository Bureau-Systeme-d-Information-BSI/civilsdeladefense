# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/job_applications/show", type: :view do
  it "renders" do
    job_application = assign(:job_application, create(:job_application))
    job_offer = assign(:job_offer, job_application.job_offer)
    assign(:message, build(:message, job_application: job_application))
    assign(:email, build(:email, job_application: job_application))
    create_list(:job_application, 5, job_offer: job_offer)

    render
  end
end
