# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Account::Emails::Attachments" do
  let(:user) { create(:confirmed_user) }
  let(:job_application) { create(:job_application, user:) }
  let(:email) { create(:email, job_application:) }
  let(:email_attachment) { create(:email_attachment, email:) }

  describe "GET /espace-candidat/mes-candidatures/:job_application_id/emails/:email_id/attachments/:id" do
    subject(:show_request) do
      get account_job_application_email_attachment_path(job_application, email, email_attachment)
    end

    context "when signed in" do
      before do
        sign_in user
        show_request
      end

      it { expect(response).to be_successful }
    end

    context "when signed out" do
      before { show_request }

      it { expect(response).to redirect_to(new_user_session_path) }
    end
  end
end
