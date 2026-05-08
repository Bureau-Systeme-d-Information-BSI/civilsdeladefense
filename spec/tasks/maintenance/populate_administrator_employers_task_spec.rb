# frozen_string_literal: true

require "rails_helper"

module Maintenance
  RSpec.describe PopulateAdministratorEmployersTask do
    describe "#collection" do
      subject(:collection) { described_class.collection }

      let!(:admin_without_employer) { create(:administrator, employer: nil) }
      let!(:admin_with_employer) { create(:administrator, employer: create(:employer)) }
      let!(:admin_already_populated) { create(:administrator, employer: create(:employer)) }

      before { admin_already_populated.employers << create(:employer) }

      it { expect(collection).to include(admin_with_employer) }

      it { expect(collection).not_to include(admin_without_employer) }

      it { expect(collection).not_to include(admin_already_populated) }
    end

    describe "#process" do
      subject(:process) { described_class.process(administrator) }
      let(:employer) { create(:employer) }
      let(:administrator) { create(:administrator, employer:) }

      it { expect { process }.to change { administrator.reload.employers }.from([]).to([employer]) }
    end
  end
end
