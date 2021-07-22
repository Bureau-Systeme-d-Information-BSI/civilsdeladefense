# frozen_string_literal: true

require "rails_helper"

RSpec.describe Organization, type: :model do
  it "is valid with valid attributes" do
    @organization = organizations(:cvd)
    expect(@organization).to be_valid
  end

  it { should validate_presence_of(:service_name) }
  it { should validate_presence_of(:brand_name) }
  it { should validate_presence_of(:prefix_article) }
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
#  atinternet_site_id            :string
#  matomo_site_id                :string
#
