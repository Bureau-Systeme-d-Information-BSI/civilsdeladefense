# frozen_string_literal: true

module Maintenance
  class PopulateJobApplicationsRejectedTask < MaintenanceTasks::Task
    def collection = JobApplication.unscoped.where(state: [1, 3, 6], rejected: false)

    def process(element) = element.update_column(:rejected, true) # rubocop:disable Rails/SkipsModelValidations
  end
end
