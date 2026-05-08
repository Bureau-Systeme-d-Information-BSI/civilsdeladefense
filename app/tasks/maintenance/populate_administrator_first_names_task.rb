# frozen_string_literal: true

module Maintenance
  class PopulateAdministratorFirstNamesTask < MaintenanceTasks::Task
    def collection = Administrator.where(first_name: [nil, ""])

    def process(administrator) = administrator.update_columns(first_name: first_name_from(administrator.email)) # rubocop:disable Rails/SkipsModelValidations

    private

    def first_name_from(email) = email.split("@").first.split(".").first.capitalize
  end
end
