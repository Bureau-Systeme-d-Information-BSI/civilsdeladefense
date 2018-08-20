class JobApplication < ApplicationRecord
  include AASM

  belongs_to :job_offer
  belongs_to :user, optional: true

  JobOffer::FILES.each do |file|
    has_one_attached file.to_sym
  end

  validates :first_name, :last_name, :current_position, :phone, presence: true

  validates_acceptance_of :terms_of_service

  enum state: {
    initial: 0,
    rejected: 1,
    phone_meeting: 2,
    phone_meeting_rejected: 3,
    phone_meeting_accepted: 4,
    to_be_met: 5,
    after_meeting_rejected: 6,
    accepted: 7,
    contract_drafting: 8,
    contract_feedback_waiting: 9,
    contract_received: 10,
    affected: 11
  }

  aasm column: :state, enum: true do
    state :initial, initial: true
    state :rejected
    state :phone_meeting
    state :phone_meeting_rejected
    state :phone_meeting_accepted
    state :to_be_met
    state :after_meeting_rejected
    state :accepted
    state :contract_drafting
    state :contract_feedback_waiting
    state :contract_received
    state :affected
  end

  def full_name
    [first_name, last_name].join(" ")
  end
end
