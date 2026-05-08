# frozen_string_literal: true

module JobApplicationsHelper
  def badge_color_for_state(state)
    case state.to_sym
    when :start
      "light invisible"
    when :initial
      "purple"
    when :draft, :archived, :suspended
      "light-gray"
    when :accepted, :published
      "success"
    when :contract_drafting, :contract_feedback_waiting, :contract_received, :affected
      "primary"
    when :phone_meeting, :to_be_met
      "info"
    end
  end

  def badge_class(state)
    "badge-#{badge_color_for_state(state)}"
  end
end
