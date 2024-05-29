class DrawbackJobOffer < ApplicationRecord
  belongs_to :drawback
  belongs_to :job_offer
end

# == Schema Information
#
# Table name: drawback_job_offers
#
#  id           :uuid             not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  drawback_id  :uuid             not null
#  job_offer_id :uuid             not null
#
# Indexes
#
#  index_drawback_job_offers_on_drawback_id   (drawback_id)
#  index_drawback_job_offers_on_job_offer_id  (job_offer_id)
#
# Foreign Keys
#
#  fk_rails_224623ffa1  (drawback_id => drawbacks.id)
#  fk_rails_e2f65b84f4  (job_offer_id => job_offers.id)
#
