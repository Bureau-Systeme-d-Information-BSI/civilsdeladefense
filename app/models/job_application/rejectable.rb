module JobApplication::Rejectable
  extend ActiveSupport::Concern

  included do
    belongs_to :rejection_reason, optional: true

    validate :missing_rejection_reason, if: -> { rejected && rejection_reason.blank? }

    before_save :cleanup_rejection_reason, unless: -> { rejected }

    scope :rejecteds, -> { where(rejected: true) }
    scope :not_rejecteds, -> { where(rejected: false) }
  end

  def reject!(rejection_reason:, from_user: false)
    if from_user && rejection_reason != RejectionReason.withdrawal_reason
      raise ArgumentError, "rejection_reason must be RejectionReason.withdrawal_reason when from_user is true"
    end

    update!(rejected: true, rejection_reason:)

    if from_user
      ApplicantNotificationsMailer.with(user:, job_offer:).notify_withdrawn.deliver_later
    else
      ApplicantNotificationsMailer.with(user:, job_offer:).notify_rejected.deliver_later
    end
  end

  def unreject! = update!(state: :initial, rejected: false, rejection_reason: nil)

  private

  def missing_rejection_reason = errors.add(:rejection_reason, :blank)

  def cleanup_rejection_reason = self.rejection_reason = nil
end
