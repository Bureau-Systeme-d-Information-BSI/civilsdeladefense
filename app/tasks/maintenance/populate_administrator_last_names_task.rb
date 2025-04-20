# frozen_string_literal: true

module Maintenance
  class PopulateAdministratorLastNamesTask < MaintenanceTasks::Task
    def collection = Administrator.where(last_name: [nil, ""])

    def process(administrator) = administrator.update_columns(last_name: last_name_from(administrator.email)) # rubocop:disable Rails/SkipsModelValidations

    private

    def last_name_from(email) = email.split("@").first.split(".").last.capitalize
  end
end
