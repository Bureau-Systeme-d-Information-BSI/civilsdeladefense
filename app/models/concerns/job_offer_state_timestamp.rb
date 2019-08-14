# frozen_string_literal: true

# Timestamp management for some state passing
module JobOfferStateTimestamp
  extend ActiveSupport::Concern

  def aasm_event_fired(event, from, to)
    if %i[published archived suspended].include?(to)
      self.send("#{to}_at=", updated_at)
    end
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
      audit.audited_changes.keys.include?('state') && audit.audited_changes['state'].last == state_name
    end
    update_column "#{state_name}_at", target_audit.created_at if target_audit
  end
end
