# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Account::Emails" do
  let(:user) { create(:confirmed_user) }
  let(:job_application) { create(:job_application, user:) }

  before { sign_in user }

  describe "GET /espace-candidat/mes-candidatures/:job_application_id/emails" do
    subject(:index_request) { get account_job_application_emails_path(job_application) }

    before { index_request }

    it { expect(response).to have_http_status(:ok) }
  end

  describe "POST /espace-candidat/mes-candidatures/:job_application_id/emails" do
    subject(:create_request) do
      post account_job_application_emails_path(job_application),
        params: {email: attributes},
        headers: {"Accept" => "text/vnd.turbo-stream.html"}
    end

    before { create_request }

    context "with valid params" do
      let(:attributes) { attributes_for(:email) }

      it { expect(response.body).to include('action="prepend"') }
    end

    context "with invalid params" do
      let(:attributes) { attributes_for(:email, subject: nil) }

      it { expect(response.body).to include('action="replace"') }
    end
  end
end
