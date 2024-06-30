# frozen_string_literal: true

require "rails_helper"

module Maintenance
  RSpec.describe PopulateMobiliaDateTask do
    describe "#process" do
      subject(:process) { described_class.process(element) }
      let(:element) { create(:job_offer) }

      before { element.update_column(:mobilia_date, nil) } # rubocop:disable Rails/SkipsModelValidations

      it { expect { process }.to change { element.reload.mobilia_date }.from(nil).to(element.created_at.to_date) }
    end
  end
end
