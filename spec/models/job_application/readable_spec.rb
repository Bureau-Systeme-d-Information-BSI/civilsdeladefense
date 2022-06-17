# frozen_string_literal: true

require "rails_helper"

RSpec.describe JobApplication::Readable, type: :model do
  describe "#mark_all_as_read!" do
    it "mark all emails as read" do
      email = create(:email, is_unread: true)
      job_application = email.job_application

      expect { job_application.mark_all_as_read! }.to change { email.reload.is_unread }.from(true).to(false)
    end

    it "mark all files as read" do
      job_application = create(:job_application, :with_job_application_file)
      file = job_application.job_application_files.first

      expect { job_application.mark_all_as_read! }.to change { file.reload.validated? }.from(false).to(true)
    end

    it "recomputes the administrator notifications count to 0" do
      job_application = create(:job_application, :with_job_application_file)
      create(:email, is_unread: true, job_application: job_application)

      job_application.compute_notifications_counter!
      expect {
        job_application.mark_all_as_read!
      }.to change {
        job_application.reload.administrator_notifications_count
      }.to(0)
    end
  end
end
