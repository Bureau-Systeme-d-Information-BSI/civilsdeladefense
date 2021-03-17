# frozen_string_literal: true

FactoryBot.define do
  factory :job_offer_actor do
    job_offer
    administrator
    role { JobOfferActor.roles.keys.first }
  end
end

# == Schema Information
#
# Table name: job_offer_actors
#
#  id               :uuid             not null, primary key
#  role             :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  administrator_id :uuid
#  job_offer_id     :uuid
#
# Indexes
#
#  index_job_offer_actors_on_administrator_id  (administrator_id)
#  index_job_offer_actors_on_job_offer_id      (job_offer_id)
#
# Foreign Keys
#
#  fk_rails_6408849d18  (administrator_id => administrators.id)
#  fk_rails_c038d3a5d4  (job_offer_id => job_offers.id)
#
