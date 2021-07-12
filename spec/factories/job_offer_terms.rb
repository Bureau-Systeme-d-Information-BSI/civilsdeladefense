FactoryBot.define do
  factory :job_offer_term do
    job_offer
    name { "MyString" }
  end
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
