# frozen_string_literal: true

# Top level organization where all other resources are tight to
# aka a customer for the SaaS platform
class Organization < ApplicationRecord
  has_many :administrators, dependent: :nullify
  has_many :job_applications, dependent: :nullify
  has_many :job_offers, dependent: :nullify
  has_many :organization_defaults, dependent: :nullify
  has_many :pages, dependent: :nullify
  has_many :users, dependent: :nullify

  validates :service_name, :brand_name, :prefix_article, presence: true

  %i[
    operator_logo
    partner_1_logo
    partner_2_logo
    partner_3_logo
    logo_horizontal
    testimony_logo
    image_background
  ].each do |field|
    mount_uploader field, LogoUploader, mount_on: :"#{field}_file_name"
    validates field, file_size: {less_than: 1.megabytes}
  end

  mount_uploader :help_file, CommonUploader

  #####################################
  # Enums
  INBOUND_EMAIL_CONFIGS = {
    not_available: 0,
    catch_all: 20
  }.freeze
  enum inbound_email_config: INBOUND_EMAIL_CONFIGS, _prefix: true

  def name
    service_name
  end

  def legal_name
    operator_name.presence || brand_name
  end

  def possessive_article
    case prefix_article
    when "le"
      "du "
    when "la"
      "de la "
    when "l'"
      "de l'"
    end
  end

  def job_offer_term?
    [
      job_offer_term_title,
      job_offer_term_subtitle,
      job_offer_term_warning
    ].all?(&:present?) && JobOfferTerm.count > 0
  end
end

# == Schema Information
#
# Table name: organizations
#
#  id                            :uuid             not null, primary key
#  administrator_email_suffix    :string
#  brand_name                    :string
#  days_before_publishing        :integer
#  facebook_url                  :string
#  help_file                     :string
#  image_background_content_type :string
#  image_background_file_name    :string
#  image_background_file_size    :bigint
#  image_background_updated_at   :datetime
#  inbound_email_config          :integer          default("not_available")
#  instagram_url                 :string
#  job_offer_term_subtitle       :string
#  job_offer_term_title          :string
#  job_offer_term_warning        :string
#  linkedin_url                  :string
#  logo_horizontal_content_type  :string
#  logo_horizontal_file_name     :string
#  logo_horizontal_file_size     :bigint
#  logo_horizontal_updated_at    :datetime
#  operator_logo_content_type    :string
#  operator_logo_file_name       :string
#  operator_logo_file_size       :bigint
#  operator_logo_updated_at      :datetime
#  operator_name                 :string
#  operator_url                  :string
#  partner_1_logo_content_type   :string
#  partner_1_logo_file_name      :string
#  partner_1_logo_file_size      :bigint
#  partner_1_logo_updated_at     :datetime
#  partner_1_name                :string
#  partner_1_url                 :string
#  partner_2_logo_content_type   :string
#  partner_2_logo_file_name      :string
#  partner_2_logo_file_size      :bigint
#  partner_2_logo_updated_at     :datetime
#  partner_2_name                :string
#  partner_2_url                 :string
#  partner_3_logo_content_type   :string
#  partner_3_logo_file_name      :string
#  partner_3_logo_file_size      :bigint
#  partner_3_logo_updated_at     :datetime
#  partner_3_name                :string
#  partner_3_url                 :string
#  prefix_article                :string
#  privacy_policy_url            :string
#  service_description           :string
#  service_description_short     :string
#  service_name                  :string
#  testimony_logo_content_type   :string
#  testimony_logo_file_name      :string
#  testimony_logo_file_size      :bigint
#  testimony_logo_updated_at     :datetime
#  testimony_subtitle            :string
#  testimony_title               :string
#  testimony_url                 :string
#  twitter_url                   :string
#  youtube_url                   :string
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#
