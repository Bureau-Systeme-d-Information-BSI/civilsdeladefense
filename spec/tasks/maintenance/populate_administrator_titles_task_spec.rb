# frozen_string_literal: true

require "rails_helper"

module Maintenance
  RSpec.describe PopulateAdministratorTitlesTask do
    describe "#collection" do
      subject(:collection) { described_class.collection }

      let!(:administrator_with_title) { create(:administrator) }
      let!(:administrator_without_title) { create(:administrator) }

      before { administrator_without_title.update_columns(title: nil) } # rubocop:disable Rails/SkipsModelValidations

      it { is_expected.to contain_exactly(administrator_without_title) }
      it { is_expected.not_to include(administrator_with_title) }
    end

    describe "#process" do
      subject(:process) { described_class.process(administrator) }

      let(:administrator) { create(:administrator) }

      before { administrator.update_columns(title: nil) } # rubocop:disable Rails/SkipsModelValidations

      it { expect { process }.to change(administrator, :title).from(nil).to("-") }
    end
  end
end
