# frozen_string_literal: true

module Maintenance
  class PopulateMobiliaDateTask < MaintenanceTasks::Task
    def collection
      JobOffer.where(mobilia_date: [nil, ""]).unscoped
    end

    def process(element)
      element.update_column(:mobilia_date, element.created_at) # rubocop:disable Rails/SkipsModelValidations
    end

    def count
      JobOffer.where(mobilia_date: [nil, ""]).unscoped.count
    end
  end
end
