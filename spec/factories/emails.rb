# frozen_string_literal: true

FactoryBot.define do
  factory :email, class: "Email" do
    subject { "New email" }

    body { "MyText" }
    job_application
    association :sender, factory: :administrator
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
