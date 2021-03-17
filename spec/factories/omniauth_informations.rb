# frozen_string_literal: true

FactoryBot.define do
  factory :omniauth_information do
    provider { :france_connect }
    uid { SecureRandom.uuid }
    email { Faker::Internet.safe_email }
    last_name { Faker::Name.last_name }
    first_name { Faker::Name.first_name }
    user factory: :confirmed_user
  end
end

# == Schema Information
#
# Table name: omniauth_informations
#
#  id         :uuid             not null, primary key
#  email      :string           not null
#  first_name :string
#  last_name  :string
#  provider   :string           not null
#  uid        :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :uuid
#
# Indexes
#
#  index_omniauth_informations_on_uid_and_provider  (uid,provider) UNIQUE
#  index_omniauth_informations_on_user_id           (user_id)
#
