# frozen_string_literal: true

require "rails_helper"

RSpec.describe Email, type: :model do
  it { should validate_presence_of(:subject) }
  it { should validate_presence_of(:body) }
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
