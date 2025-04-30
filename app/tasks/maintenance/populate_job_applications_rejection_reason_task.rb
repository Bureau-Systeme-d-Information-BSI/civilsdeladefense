# frozen_string_literal: true

module Maintenance
  class PopulateJobApplicationsRejectionReasonTask < MaintenanceTasks::Task
    def collection = JobApplication.unscoped.where(state: [1, 3, 6], rejection_reason: nil)

    def process(element) = element.update_column(:rejection_reason_id, rejection_reason.id) # rubocop:disable Rails/SkipsModelValidations

    private

    def rejection_reason = RejectionReason.find_by(name: "Refus").presence || RejectionReason.create!(name: "Refus")
  end
end
