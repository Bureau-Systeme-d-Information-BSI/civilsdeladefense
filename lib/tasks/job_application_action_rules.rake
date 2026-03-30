# frozen_string_literal: true

namespace :job_application_action_rules do
  desc "Rebuild all job application action rules from scratch"
  task rebuild: :environment do
    JobApplicationActionRule.destroy_all

    JobApplication.states.each_key do |state|
      attrs = {role: :employment_authority, state:, read: true, send_email: true}

      case state
      when "accepted"
        attrs.merge!(manage_state: true, to_state: :contract_drafting, comment: true, validate_dar: true)
      when "contract_drafting"
        attrs[:manage_state] = true
        attrs[:to_state] = :accepted
      end

      JobApplicationActionRule.create!(attrs)
    end

    puts "Created #{JobApplicationActionRule.count} job application action rules"
  end
end
