# frozen_string_literal: true

FactoryBot.define do
  factory :email_template do
    title { "MyString" }
    subject { "MyString" }

    body { "MyText" }
  end
end

# == Schema Information
#
# Table name: email_templates
#
#  id         :uuid             not null, primary key
#  body       :text
#  position   :integer
#  subject    :string
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_email_templates_on_position  (position)
#
