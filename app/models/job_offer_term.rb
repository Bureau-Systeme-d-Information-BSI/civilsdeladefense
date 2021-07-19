class JobOfferTerm < ApplicationRecord
  acts_as_list
  default_scope -> { order(position: :asc) }
end

# == Schema Information
#
# Table name: job_offer_terms
#
#  id         :uuid             not null, primary key
#  name       :string
#  position   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
