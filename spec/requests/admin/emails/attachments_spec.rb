# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::Emails::Attachments" do
  let(:job_application) { create(:job_application) }
  let(:email) { create(:email, job_application:) }
  let(:email_attachment) { create(:email_attachment, email:) }

  before { sign_in create(:administrator) }

  describe "GET /admin/candidatures/:job_application_id/emails/:email_id/attachments/:id" do
    subject(:show_request) do
      get admin_job_application_email_attachment_path(job_application, email, email_attachment)
    end

    before { show_request }

    it { expect(response).to be_successful }
  end
end
