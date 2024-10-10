require "rails_helper"

RSpec.describe "Admin::Resumes" do
  before { sign_in create(:administrator) }

  describe "GET /admin/users/:user_id/resume" do
    subject(:show_request) { get admin_user_resume_path(user) }

    let(:user) { create(:user, profile: create(:profile, :with_resume)) }

    before { show_request }

    it { expect(response).to be_successful }

    it { expect(response.headers["Content-Type"]).to eq "application/pdf" }
  end
end
