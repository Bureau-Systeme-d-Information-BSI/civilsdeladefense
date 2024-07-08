# frozen_string_literal: true

require "rails_helper"

module Maintenance
  RSpec.describe PopulateCspValueTask do
    describe "#process" do
      subject(:process) { described_class.process(element) }
      let(:element) { create(:job_offer) }

      before { element.update_column(:csp_value, nil) } # rubocop:disable Rails/SkipsModelValidations

      it { expect { process }.to change { element.reload.csp_value }.from(nil).to("inconnue") }
    end
  end
end
