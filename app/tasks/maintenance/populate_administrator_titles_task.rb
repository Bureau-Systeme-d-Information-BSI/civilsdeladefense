# frozen_string_literal: true

module Maintenance
  class PopulateAdministratorTitlesTask < MaintenanceTasks::Task
    def collection = Administrator.where(title: [nil, ""])

    def process(administrator) = administrator.update_columns(title: "-") # rubocop:disable Rails/SkipsModelValidations
  end
end
