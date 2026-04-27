# frozen_string_literal: true

module Maintenance
  class AddWithdrawalRejectionReasonTask < MaintenanceTasks::Task
    no_collection

    def process
      RejectionReason.create!(name: "Désistement du/de la candidat.e")
    end
  end
end
