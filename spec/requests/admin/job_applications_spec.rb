require 'rails_helper'

RSpec.describe "Admin::JobApplications", type: :request do

  describe "GET /admin/job_applications" do
    it "works! (now write some real specs)" do
      admin = create(:administrator)
      admin.confirm
      sign_in admin
      get admin_job_applications_path
      expect(response).to have_http_status(200)
    end
  end
end
