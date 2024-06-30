# frozen_string_literal: true

require "rails_helper"

module Maintenance
  RSpec.describe PopulateMobiliaValueTask do
    describe "#process" do
      subject(:process) { described_class.process(element) }
      let(:element) { create(:job_offer) }

      before { element.update_column(:mobilia_value, nil) } # rubocop:disable Rails/SkipsModelValidations

      it { expect { process }.to change { element.reload.mobilia_value }.from(nil).to("inconnue") }
    end
  end
end
