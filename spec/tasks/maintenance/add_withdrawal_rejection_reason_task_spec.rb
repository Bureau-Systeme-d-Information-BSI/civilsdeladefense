# frozen_string_literal: true

require "rails_helper"

module Maintenance
  RSpec.describe AddWithdrawalRejectionReasonTask do
    describe "#process" do
      subject(:process) { described_class.process() }
      
      it "creates a RejectionReason" do
        expect { process }.to change(RejectionReason, :count).by 1
      end

      it "gives the right name to the RejectionReason" do
        RejectionReason.delete_all
        process

        expect(RejectionReason.last.name).to eq("Désistement du/de la candidat.e")
      end
    end
  end
end
