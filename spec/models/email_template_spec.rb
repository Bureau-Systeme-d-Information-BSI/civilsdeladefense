# frozen_string_literal: true

require "rails_helper"

RSpec.describe EmailTemplate, type: :model do
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:subject) }
  it { should validate_presence_of(:body) }
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
