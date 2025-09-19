# frozen_string_literal: true

require "rails_helper"

module Maintenance
  RSpec.describe PopulateAdministratorFirstNamesTask do
    describe "#collection" do
      subject(:collection) { described_class.collection }
      let!(:administrator_without_first_name) { create(:administrator) }
      let!(:administrator_with_first_name) { create(:administrator) }

      before { administrator_without_first_name.update_columns(first_name: nil) } # rubocop:disable Rails/SkipsModelValidations

      it { expect(collection).to contain_exactly(administrator_without_first_name) }

      it { expect(collection).not_to include(administrator_with_first_name) }
    end

    describe "#process" do
      subject(:process) { described_class.process(administrator) }

      context "when the administrator email contains a first name" do
        let(:administrator) { create(:administrator, email: "john.doe@example.com") }

        before { administrator.update_columns(first_name: nil) } # rubocop:disable Rails/SkipsModelValidations

        it { expect { process }.to change(administrator, :first_name).from(nil).to("John") }
      end

      context "when the administrator email does not contain a first name" do
        let(:administrator) { create(:administrator, email: "brh@example.com") }

        before { administrator.update_columns(first_name: nil) } # rubocop:disable Rails/SkipsModelValidations

        it { expect { process }.to change(administrator, :first_name).from(nil).to("Brh") }
      end
    end
  end
end
