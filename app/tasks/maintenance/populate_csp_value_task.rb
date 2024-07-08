# frozen_string_literal: true

module Maintenance
  class PopulateCspValueTask < MaintenanceTasks::Task
    def collection
      JobOffer.where(csp_value: [nil, ""]).unscoped
    end

    def process(element)
      element.update_column(:csp_value, "inconnue") # rubocop:disable Rails/SkipsModelValidations
    end

    def count
      JobOffer.where(csp_value: [nil, ""]).unscoped.count
    end
  end
end
