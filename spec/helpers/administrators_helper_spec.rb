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

  describe "#employers" do
    subject { helper.employers(administrator) }

    context "when administrator is a functional administrator" do
      let(:administrator) { build(:administrator, roles: [:functional_administrator]) }

      it { is_expected.to be_blank }
    end

    context "when administrator is not a functional administrator" do
      let(:administrator) { build(:administrator, roles: [:employer_recruiter]) }
      let(:employers) { [build(:employer, code: "EMP1"), build(:employer, code: "EMP2")] }

      before { allow(administrator).to receive(:employers).and_return(employers) }

      it { is_expected.to eq(employers.pluck(:code).to_sentence) }
    end
  end
end
