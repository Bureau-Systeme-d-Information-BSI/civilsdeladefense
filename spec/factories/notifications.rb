FactoryBot.define do
  factory :notification do
    recipient { nil }
    job_offer { nil }
    job_application { nil }
    daily { false }
    kind { "MyString" }
    instigator { nil }
  end
end

# == Schema Information
#
# Table name: notifications
#
#  id                 :uuid             not null, primary key
#  daily              :boolean          default(FALSE)
#  kind               :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  instigator_id      :uuid
#  job_application_id :uuid
#  job_offer_id       :uuid
#  recipient_id       :uuid             not null
#
# Indexes
#
#  index_notifications_on_instigator_id       (instigator_id)
#  index_notifications_on_job_application_id  (job_application_id)
#  index_notifications_on_job_offer_id        (job_offer_id)
#  index_notifications_on_recipient_id        (recipient_id)
#
# Foreign Keys
#
#  fk_rails_0595cf6733  (job_application_id => job_applications.id)
#  fk_rails_44e540a267  (instigator_id => administrators.id)
#  fk_rails_4aea6afa11  (recipient_id => administrators.id)
#  fk_rails_53ccaf6ba7  (job_offer_id => job_offers.id)
#
