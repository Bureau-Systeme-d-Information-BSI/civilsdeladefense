# frozen_string_literal: true

module Maintenance
  class PopulateDepartmentProfilesTask < MaintenanceTasks::Task
    def collection = DepartmentUser.all

    def process(element)
      return unless (profile = element.user.profile)
      return unless (department = element.department)

      DepartmentProfile.find_or_create_by!(profile: profile, department: department)
    end

    delegate :count, to: :collection
  end
end
