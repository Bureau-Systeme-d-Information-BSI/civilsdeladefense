# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::JobOffers::ReadingsController, type: :request do
  before { sign_in create(:administrator) }

  describe "POST /create" do
    it "marks all job applications as read and redirects back" do
      job_application = create(:job_application, :with_job_application_file)
      create(:email, is_unread: true, job_application: job_application)
      job_application.compute_notifications_counter!
      job_offer = job_application.job_offer

      expect {
        post admin_job_offers_readings_path(job_offer)
      }.to change {
        job_offer.reload.notifications_count
      }.to(0)
      expect(response).to redirect_to([:admin, job_offer])
    end
  end
end
