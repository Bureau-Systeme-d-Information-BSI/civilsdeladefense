# frozen_string_literal: true

require "rails_helper"

RSpec.describe JobApplication::Readable do
  describe "#mark_all_as_read!" do
    it "mark all emails as read" do
      email = create(:email, is_unread: true)
      job_application = email.job_application

      expect { job_application.mark_all_as_read! }.to change { email.reload.is_unread }.from(true).to(false)
    end
  end
end
