# frozen_string_literal: true

module Maintenance
  class PopulateCspDateTask < MaintenanceTasks::Task
    def collection
      JobOffer.where(csp_date: [nil, ""]).unscoped
    end

    def process(element)
      element.update_column(:csp_date, element.created_at) # rubocop:disable Rails/SkipsModelValidations
    end

    def count
      JobOffer.where(csp_date: [nil, ""]).unscoped.count
    end
  end
end
