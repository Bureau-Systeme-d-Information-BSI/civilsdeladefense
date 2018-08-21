module JobApplicationsHelper
  def badge_color_for_state(state)
    case state
    when :initial
      'purple'
    when :rejected, :phone_meeting_rejected, :after_meeting_rejected, :draft, :archived
      'light-gray'
    when :phone_meeting_accepted, :accepted
      'success'
    when :contract_drafting, :contract_feedback_waiting, :contract_received, :affected
      'primary'
    when :phone_meeting, :to_be_met
      'info'
    end
  end

  def badge_class(state)
    "badge-#{ badge_color_for_state(state) }"
  end
end
