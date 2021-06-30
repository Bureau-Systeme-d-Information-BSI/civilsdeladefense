class BenefitJobOffer < ApplicationRecord
  belongs_to :benefit
  belongs_to :job_offer
end

# == Schema Information
#
# Table name: benefit_job_offers
#
#  id           :uuid             not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  benefit_id   :uuid             not null
#  job_offer_id :uuid             not null
#
# Indexes
#
#  index_benefit_job_offers_on_benefit_id    (benefit_id)
#  index_benefit_job_offers_on_job_offer_id  (job_offer_id)
#
# Foreign Keys
#
#  fk_rails_4c8e56e12f  (job_offer_id => job_offers.id)
#  fk_rails_a2a7906d62  (benefit_id => benefits.id)
#
