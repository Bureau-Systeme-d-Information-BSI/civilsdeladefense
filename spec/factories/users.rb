# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    organization { Organization.first }
    first_name { Faker::Name.unique.first_name }
    last_name { Faker::Name.unique.last_name }
    current_position { "CEO" }
    phone { "06" }
    website_url { "MyString" }
    email { Faker::Internet.unique.safe_email }
    password { "f4k3p455w0rD!" }
    terms_of_service { true }
    certify_majority { true }
  end

  factory :confirmed_user, parent: :user do
    after(:create, &:confirm)
  end
end

# == Schema Information
#
# Table name: users
#
#  id                               :uuid             not null, primary key
#  confirmation_sent_at             :datetime
#  confirmation_token               :string
#  confirmed_at                     :datetime
#  current_position                 :string
#  current_sign_in_at               :datetime
#  current_sign_in_ip               :inet
#  email                            :string           default(""), not null
#  encrypted_file_transfer_in_error :boolean          default(FALSE)
#  encrypted_password               :string           default(""), not null
#  failed_attempts                  :integer          default(0), not null
#  first_name                       :string
#  job_applications_count           :integer          default(0), not null
#  last_name                        :string
#  last_sign_in_at                  :datetime
#  last_sign_in_ip                  :inet
#  locked_at                        :datetime
#  marked_for_deletion_on           :date
#  phone                            :string
#  photo_content_type               :string
#  photo_file_name                  :string
#  photo_file_size                  :bigint
#  photo_is_validated               :integer          default(0)
#  photo_updated_at                 :datetime
#  receive_job_offer_mails          :boolean          default(FALSE)
#  remember_created_at              :datetime
#  reset_password_sent_at           :datetime
#  reset_password_token             :string
#  sign_in_count                    :integer          default(0), not null
#  suspended_at                     :datetime
#  suspension_reason                :string
#  unconfirmed_email                :string
#  unlock_token                     :string
#  website_url                      :string
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#  organization_id                  :uuid
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_organization_id       (organization_id)
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_unlock_token          (unlock_token) UNIQUE
#
