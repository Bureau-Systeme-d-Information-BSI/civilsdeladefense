# frozen_string_literal: true

module JobApplicationsHelper
  def badge_color_for_state(state)
    case state.to_sym
    when :start
      "light invisible"
    when :initial
      "purple"
    when :rejected, :phone_meeting_rejected, :after_meeting_rejected, :draft, :archived, :suspended
      "light-gray"
    when :accepted, :published
      "success"
    when :contract_drafting, :contract_feedback_waiting, :contract_received, :affected
      "primary"
    when :phone_meeting, :to_be_met
      "info"
    end
  end

  def profile_value_for_attribute(profile, attribute)
    case attribute
    when :gender
      enum_i18n(Profile, :gender, profile.send(attribute))
    when :has_corporate_experience
      I18n.t(profile.send(attribute))
    when :study_level, :experience_level, :age_range, :availability_range
      profile.send(attribute).name
    end
  end

  def badge_class(state)
    "badge-#{badge_color_for_state(state)}"
  end
end
