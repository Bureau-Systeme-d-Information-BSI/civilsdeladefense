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
    target_audit = audits.reorder(version: :desc).detect do |audit|
      state_has_changed = audit.audited_changes.keys.include?('state')
      state_has_changed && audit.audited_changes['state'].last == state_name
    end
    update_column "#{state_name}_at", target_audit.created_at if target_audit
  end
end
