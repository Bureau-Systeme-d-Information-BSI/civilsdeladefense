class JobApplication < ApplicationRecord
  include AASM
  audited
  has_associated_audits

  belongs_to :job_offer
  belongs_to :user
  belongs_to :employer
  accepts_nested_attributes_for :user
  has_many :messages
  has_many :emails

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

  before_validation :set_employer

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

    event :reject do
      transitions from: [:initial], to: :rejected
    end

  end

  counter_culture :job_offer,
    column_name: Proc.new {|model| "#{ model.state }_job_applications_count" },
    column_names: aasm.states.inject({}) { |memo, obj|
      state = obj.name
      enum_value = states[ state ]
      memo[ ["job_applications.state = ?", enum_value] ] = "#{ state }_job_applications_count"
      memo
    },
    touch: true
  counter_culture :job_offer,
    column_name: 'job_applications_count'

  def full_name
    [first_name, last_name].join(" ")
  end

  def address_short
    ary = []
    ary << city if city.present?
    ary << country if country.present?
    ary.join(" ")
  end

  def set_employer
    self.employer_id = self.job_offer.employer_id
  end
end
