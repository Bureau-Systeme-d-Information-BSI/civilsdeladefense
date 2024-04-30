require "rails_helper"

RSpec.describe AdministratorsHelper do
  describe "#actor_roles_or_general_role" do
    subject { helper.actor_roles_or_general_role(administrator) }

    let(:administrator) { build(:administrator) }

    context "when administrator has actor roles" do
      before do
        administrator.save!
        job_offer = create(:job_offer)
        create(:job_offer_actor, job_offer:, administrator:, role: :cmg)
        create(:job_offer_actor, job_offer:, administrator:, role: :brh)
        create(:job_offer_actor, job_offer:, administrator:, role: :grand_employer)
      end

      it { is_expected.to eq("CMG, RH et Grand Employeur") }
    end

    context "when administrator has general role" do
      before { allow(administrator).to receive(:role).and_return(:employer) }

      it { is_expected.to eq("Employeur") }
    end

    context "when administrator has no roles" do
      before { allow(administrator).to receive(:role).and_return(nil) }

      it { is_expected.to be_nil }
    end
  end
end
