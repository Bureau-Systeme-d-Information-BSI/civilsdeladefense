# frozen_string_literal: true

require "rails_helper"

module Maintenance
  RSpec.describe PopulateAdministratorRolesTask do
    describe "#collection" do
      subject(:collection) { described_class.collection }

      let!(:administrator_with_roles) { create(:administrator, roles: [:functional_administrator]) }
      let!(:administrator_without_roles) { create(:administrator) }

      before { administrator_without_roles.update_column(:roles, []) } # rubocop:disable Rails/SkipsModelValidations

      it { expect(collection).to contain_exactly(administrator_without_roles) }

      it { expect(collection).not_to include(administrator_with_roles) }
    end

    describe "#process" do
      subject(:process) { described_class.process(administrator) }

      let(:administrator) { create(:administrator, role:) }

      before { administrator.update_column(:roles, []) } # rubocop:disable Rails/SkipsModelValidations

      context "when administrator role is admin" do
        let(:role) { 0 } # admin

        it { expect { process }.to change { administrator.reload.roles }.to([:functional_administrator]) }
      end

      context "when administrator role is employer" do
        let(:role) { 1 } # employer

        it { expect { process }.to change { administrator.reload.roles }.to([:employer_recruiter]) }
      end

      context "when administrator job offer actor role is employer" do
        let(:role) { nil }

        before { create(:job_offer_actor, administrator:, role: :employer) }

        it { expect { process }.to change { administrator.reload.roles }.to([:employer_recruiter]) }
      end

      context "when administrator job offer actor role is grand employer" do
        let(:role) { nil }

        before { create(:job_offer_actor, administrator:, role: :grand_employer) }

        it { expect { process }.to change { administrator.reload.roles }.to([:employment_authority]) }
      end

      context "when administrator job offer actor role is supervisor employer" do
        let(:role) { nil }

        before { create(:job_offer_actor, administrator:, role: :supervisor_employer) }

        it { expect { process }.to change { administrator.reload.roles }.to([:employment_authority]) }
      end

      context "when administrator job offer actor role is brh" do
        let(:role) { nil }

        before { create(:job_offer_actor, administrator:, role: :brh) }

        it { expect { process }.to change { administrator.reload.roles }.to([:hr_manager, :payroll_manager]) }
      end

      context "when administrator job offer actor role is cmg" do
        let(:role) { nil }

        before { create(:job_offer_actor, administrator:, role: :cmg) }

        it { expect { process }.to change { administrator.reload.roles }.to([:hr_manager, :payroll_manager]) }
      end

      context "when administrator has a role and multiple job offer actor roles" do
        let(:role) { 0 } # admin

        before do
          create(:job_offer_actor, administrator:, role: :supervisor_employer)
          create(:job_offer_actor, administrator:, role: :cmg)
        end

        it do
          expect { process }.to change { administrator.reload.roles }.to(
            [
              :functional_administrator,
              :employment_authority,
              :hr_manager,
              :payroll_manager
            ]
          )
        end
      end
    end
  end
end
