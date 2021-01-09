# frozen_string_literal: true

# Timestamp management for some state passing
module JobOfferStateTimestamp
  extend ActiveSupport::Concern

  def set_timestamp
    to = aasm.to_state
    send("#{to}_at=", updated_at) if %i[published archived suspended].include?(to)
  end

  def rebuild_published_timestamp!
    rebuild_timestamp!('published')
  end

  def rebuild_archived_timestamp!
    rebuild_timestamp!('archived')
  end

  def rebuild_suspended_timestamp!
    rebuild_timestamp!('suspended')
  end

  def rebuild_timestamp!(state_name)
    enum_val = JobOffer.states[state_name]
    target_audit = audits.reorder(version: :desc).detect do |audit|
      state_val = audit.audited_changes['state']
      return false if state_val.nil?

      case state_val
      when Array
        state_val.last == enum_val
      when String
        state_val == enum_val
      end
    end
    update_column "#{state_name}_at", target_audit.created_at if target_audit
  end
end
