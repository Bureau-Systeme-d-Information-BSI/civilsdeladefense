module JobApplication::Rejectable
  extend ActiveSupport::Concern

  included do
    belongs_to :rejection_reason, optional: true

    validate :missing_rejection_reason, if: -> { rejected && rejection_reason.blank? }

    before_save :cleanup_rejection_reason, unless: -> { rejected }
    after_update :notify_rejected, if: -> { saved_change_to_rejected? && rejected }

    scope :rejecteds, -> { where(rejected: true) }
    scope :not_rejecteds, -> { where(rejected: false) }
  end

  def reject!(rejection_reason:) = update!(rejected: true, rejection_reason:)

  private

  def missing_rejection_reason = errors.add(:rejection_reason, :blank)

  def cleanup_rejection_reason = self.rejection_reason = nil

  def notify_rejected = ApplicantNotificationsMailer.with(user:, job_offer:).notify_rejected.deliver_later
end
