# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/job_applications/edit", type: :view do
  it "renders the edit job_application form" do
    job_application = assign(:job_application, create(:job_application))

    render

    url = admin_job_application_path(job_application)
    assert_select "form[action=?][method=?]", url, "post" do
    end
  end
end
