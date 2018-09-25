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

  JobOffer::FILES.each do |field|
    has_attached_file field.to_sym
    validates_with AttachmentPresenceValidator,
      attributes: field.to_sym,
      if: Proc.new { |job_application|
        job_application.job_offer.send("mandatory_option_#{field}?")
      }
    validates_with AttachmentContentTypeValidator,
      attributes: field.to_sym,
      content_type: (field == :photo ? /\Aimage\/.*\z/ : "application/pdf")
    validates_with AttachmentSizeValidator,
      attributes: field.to_sym,
      less_than: (field == :photo ? 1.megabyte : 2.megabytes)
  end

  validates :first_name, :last_name, :current_position, :phone, presence: true
  validates :terms_of_service, acceptance: true
  JobOffer::URLS.each do |field|
    validates field.to_sym, presence: true, if: Proc.new { |job_application|
      job_application.job_offer.send("mandatory_option_#{field}?")
    }
  end

  before_validation :set_employer

  FINISHED_STATES = %i(rejected phone_meeting_rejected after_meeting_rejected affected).freeze
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

  def self.end_user_states_regrouping
    @end_user_states_regrouping ||= [
      [:initial, :rejected],
      [:phone_meeting, :phone_meeting_rejected, :phone_meeting_accepted],
      [:to_be_met, :after_meeting_rejected],
      [:accepted],
      [:contract_drafting],
      [:contract_feedback_waiting],
      [:contract_received],
      [:affected]
    ]
  end

  def end_user_state_number
    self.class.end_user_states_regrouping.index { |x| x.include?(state.to_sym) }
  end

  def end_user_state
    "end_user_state_#{end_user_state_number}"
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

  scope :finished, -> { where(state: FINISHED_STATES) }
  scope :not_finished, -> { where.not(state: FINISHED_STATES) }

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
    self.employer_id ||= self.job_offer.employer_id
  end
end
