# frozen_string_literal: true

module Maintenance
  class PopulateAdministratorEmployersTask < MaintenanceTasks::Task
    def collection = Administrator.where.missing(:administrator_employers).where.not(employer: nil)

    def process(administrator) = administrator.administrator_employers.create!(employer: administrator.employer)
  end
end
