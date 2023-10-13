# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Account::Emails" do
  describe "GET /mon-compte/candidatures/XXX/emails" do
    it "works! (now write some real specs)" do
      user = create(:user)
      user.confirm
      sign_in user

      job_application = create(:job_application, user: user)
      get account_job_application_emails_path(job_application)
      expect(response).to have_http_status(:ok)
    end
  end
end
