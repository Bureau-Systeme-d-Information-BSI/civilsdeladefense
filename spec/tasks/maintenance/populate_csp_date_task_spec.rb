# frozen_string_literal: true

require "rails_helper"

module Maintenance
  RSpec.describe PopulateCspDateTask do
    describe "#process" do
      subject(:process) { described_class.process(element) }
      let(:element) { create(:job_offer) }

      before { element.update_column(:csp_date, nil) } # rubocop:disable Rails/SkipsModelValidations

      it { expect { process }.to change { element.reload.csp_date }.from(nil).to(element.created_at.to_date) }
    end
  end
end
