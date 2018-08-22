class JobApplication < ApplicationRecord
  include AASM

  belongs_to :job_offer
  belongs_to :user, optional: true

  JobOffer::FILES.each do |file|
    has_one_attached file.to_sym
  end

  validates :first_name, :last_name, :current_position, :phone, presence: true
  validates :terms_of_service, acceptance: true
  JobOffer::URLS.each do |field|
    validates field.to_sym, presence: true, if: Proc.new { |job_application|
      job_application.job_offer.send("mandatory_option_#{field}?")
    }
  end

  JobOffer::FILES.each do |field|
    validates field.to_sym, mandatory_file: true
  end

  validates :photo, file_size: { less_than_or_equal_to: 1.megabytes },
                    file_content_type: { allow: ['image/jpg', 'image/jpeg', 'image/png'] },
                    if: -> { photo.attached? }

  validates :cover_letter, file_size: { less_than_or_equal_to: 2.megabytes },
                           file_content_type: { allow: ['application/pdf'] },
                           if: -> { cover_letter.attached? }

  validates :resume, file_size: { less_than_or_equal_to: 2.megabytes },
                     file_content_type: { allow: ['application/pdf'] },
                     if: -> { resume.attached? }

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
