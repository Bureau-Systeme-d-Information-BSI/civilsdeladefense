# frozen_string_literal: true

module Maintenance
  class AddWithdrawalRejectionReasonTask < MaintenanceTasks::Task
    no_collection

    def process
      return if RejectionReason.withdrawal_reason

      RejectionReason.create!(name: RejectionReason::WITHDRAWAL_REASON)
    end
  end
end
