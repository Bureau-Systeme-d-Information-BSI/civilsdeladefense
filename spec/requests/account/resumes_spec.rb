require "rails_helper"

RSpec.describe "Account::Resumes" do
  let(:user) { create(:confirmed_user) }

  before { sign_in user }

  describe "GET /espace-candidat/mon-profil/resume" do
    subject(:show_request) { get account_profiles_resume_path }

    before { show_request }

    it { expect(response).to be_successful }

    it { expect(response.headers["Content-Type"]).to eq "application/pdf" }
  end
end
