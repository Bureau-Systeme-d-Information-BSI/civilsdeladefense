# frozen_string_literal: true

# User information from omniauth provider
class OmniauthInformation < ApplicationRecord
  AVAILABLE_PROVIDERS = %w[france_connect].freeze

  belongs_to :user

  validates :uid, :email, :provider, presence: true
  validates :uid, uniqueness: { scope: :provider }
  validates :provider, inclusion: { in: AVAILABLE_PROVIDERS }
end
