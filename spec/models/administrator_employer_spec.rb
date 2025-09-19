require "rails_helper"

RSpec.describe AdministratorEmployer do
  describe "associations" do
    it { is_expected.to belong_to(:administrator) }
    it { is_expected.to belong_to(:employer) }
  end
end

# == Schema Information
#
# Table name: administrator_employers
#
#  id               :uuid             not null, primary key
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  administrator_id :uuid             not null
#  employer_id      :uuid             not null
#
# Indexes
#
#  index_administrator_employers_on_administrator_id  (administrator_id)
#  index_administrator_employers_on_employer_id       (employer_id)
#
# Foreign Keys
#
#  fk_rails_9828dff21a  (administrator_id => administrators.id)
#  fk_rails_a2ab005732  (employer_id => employers.id)
#
