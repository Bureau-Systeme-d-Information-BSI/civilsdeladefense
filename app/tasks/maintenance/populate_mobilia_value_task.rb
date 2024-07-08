# frozen_string_literal: true

module Maintenance
  class PopulateMobiliaValueTask < MaintenanceTasks::Task
    def collection
      JobOffer.where(mobilia_value: [nil, ""]).unscoped
    end

    def process(element)
      element.update_column(:mobilia_value, "inconnue") # rubocop:disable Rails/SkipsModelValidations
    end

    def count
      JobOffer.where(mobilia_value: [nil, ""]).unscoped.count
    end
  end
end
