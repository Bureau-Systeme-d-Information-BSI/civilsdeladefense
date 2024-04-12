require "rails_helper"

RSpec.describe Bookmark do
  describe "associations" do
    it { is_expected.to belong_to(:job_offer) }
    it { is_expected.to belong_to(:user) }
  end
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
