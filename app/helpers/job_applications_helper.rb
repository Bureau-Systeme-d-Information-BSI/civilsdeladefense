# frozen_string_literal: true

module JobApplicationsHelper
  # rubocop:disable Metrics/CyclomaticComplexity:
  def badge_color_for_state(state)
    case state
    when :start
      'light invisible'
    when :initial
      'purple'
    when :rejected, :phone_meeting_rejected, :after_meeting_rejected, :draft, :archived, :suspended
      'light-gray'
    when :accepted, :published
      'success'
    when :contract_drafting, :contract_feedback_waiting, :contract_received, :affected
      'primary'
    when :phone_meeting, :to_be_met
      'info'
    end
  end
  # rubocop:enable Metrics/CyclomaticComplexity:

  def badge_class(state)
    "badge-#{badge_color_for_state(state)}"
  end
end
