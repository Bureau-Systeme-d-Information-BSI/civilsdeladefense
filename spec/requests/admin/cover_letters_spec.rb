# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::CoverLetters" do
  before { sign_in create(:administrator) }

  describe "GET /admin/candidatures/:job_application_id/cover_letter" do
    subject(:show_request) { get admin_job_application_cover_letter_path(job_application) }

    let(:job_application) { create(:job_application, :with_cover_letter) }

    before { show_request }

    it { expect(response).to be_successful }

    it { expect(response.headers["Content-Type"]).to eq "application/pdf" }
  end
end
