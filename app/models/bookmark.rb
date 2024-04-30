class Bookmark < ApplicationRecord
  belongs_to :job_offer
  belongs_to :user

  validates :job_offer_id, uniqueness: {scope: :user_id}
end

# == Schema Information
#
# Table name: bookmarks
#
#  id           :uuid             not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  job_offer_id :uuid             not null
#  user_id      :uuid             not null
#
# Indexes
#
#  index_bookmarks_on_job_offer_id              (job_offer_id)
#  index_bookmarks_on_job_offer_id_and_user_id  (job_offer_id,user_id) UNIQUE
#  index_bookmarks_on_user_id                   (user_id)
#
# Foreign Keys
#
#  fk_rails_3d72e3e731  (job_offer_id => job_offers.id)
#  fk_rails_c1ff6fa4ac  (user_id => users.id)
#
