# frozen_string_literal: true

# User information from omniauth provider
class OmniauthInformation < ApplicationRecord
  AVAILABLE_PROVIDERS = %w[france_connect].freeze

  belongs_to :user

  validates :uid, :email, :provider, presence: true
  validates :uid, uniqueness: {scope: :provider}
  validates :provider, inclusion: {in: AVAILABLE_PROVIDERS}
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
