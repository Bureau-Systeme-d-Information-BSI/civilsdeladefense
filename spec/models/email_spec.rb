# frozen_string_literal: true

require "rails_helper"

RSpec.describe Email, type: :model do
  it { should validate_presence_of(:subject) }
  it { should validate_presence_of(:body) }

  describe "#mark_as_read!" do
    it "marks the email as read" do
      email = create(:email, is_unread: true)
      expect { email.mark_as_read! }.to change { email.reload.is_unread }.from(true).to(false)
    end
  end

  describe "#mark_as_unread!" do
    it "marks the email as unread" do
      email = create(:email, is_unread: false)
      expect { email.mark_as_unread! }.to change { email.reload.is_unread }.from(false).to(true)
    end
  end
end

# == Schema Information
#
# Table name: emails
#
#  id                 :uuid             not null, primary key
#  body               :text
#  is_unread          :boolean          default(TRUE)
#  sender_type        :string
#  subject            :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  job_application_id :uuid
#  sender_id          :uuid
#
# Indexes
#
#  index_emails_on_job_application_id         (job_application_id)
#  index_emails_on_sender_type_and_sender_id  (sender_type,sender_id)
#
# Foreign Keys
#
#  fk_rails_ebb3716bca  (job_application_id => job_applications.id)
#
