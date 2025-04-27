require "rails_helper"

RSpec.describe AdministratorsHelper do
  describe "#roles" do
    subject { helper.roles(administrator) }

    context "when administrator has roles" do
      let(:administrator) { build(:administrator, roles: [:employer_recruiter, :hr_manager]) }

      it { is_expected.to eq("Employeur recruteur et Gestionnaire RH") }
    end

    context "when administrator has no roles" do
      let(:administrator) { build(:administrator, roles: []) }

      it { is_expected.to be_blank }
    end
  end
end
