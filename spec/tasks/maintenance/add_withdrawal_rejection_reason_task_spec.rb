# frozen_string_literal: true

require "rails_helper"

module Maintenance
  RSpec.describe AddWithdrawalRejectionReasonTask do
    describe "#process" do
      subject(:process) { described_class.process() }

      context "when the withdrawal rejection reason does not exist" do
        it "creates a RejectionReason" do
          expect { process }.to change(RejectionReason, :count).by(1)
        end

        it "gives the right name to the RejectionReason" do
          RejectionReason.delete_all
          process
          expect(RejectionReason.last.name).to eq(RejectionReason::WITHDRAWAL_REASON)
        end
      end

      context "when the withdrawal rejection reason already exists" do
        before { create(:rejection_reason, name: RejectionReason::WITHDRAWAL_REASON) }

        it "does not create a duplicate" do
          expect { process }.not_to change(RejectionReason, :count)
        end
      end
    end
  end
end
