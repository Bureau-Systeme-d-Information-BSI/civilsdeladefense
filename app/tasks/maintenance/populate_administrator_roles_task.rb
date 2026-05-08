# frozen_string_literal: true

module Maintenance
  class PopulateAdministratorRolesTask < MaintenanceTasks::Task
    def collection
      Administrator
        .not_functional_administrator
        .not_employer_recruiter
        .not_employment_authority
        .not_hr_manager
        .not_payroll_manager
    end

    def process(administrator)
      roles = [
        case administrator.role
        when 0 then :functional_administrator
        when 1 then :employer_recruiter
        end
      ]

      job_offer_actors_roles(administrator).each do |actor_role|
        roles << case actor_role
        when "employer" then :employer_recruiter
        when "grand_employer" then :employment_authority
        when "supervisor_employer" then :employment_authority
        when "brh" then [:hr_manager, :payroll_manager]
        when "cmg" then [:hr_manager, :payroll_manager]
        end
      end
      administrator.update_column(:roles, roles.flatten.compact.uniq) # rubocop:disable Rails/SkipsModelValidations
    end

    private

    def job_offer_actors_roles(administrator) = administrator.job_offer_actors.pluck(:role).compact.uniq
  end
end
