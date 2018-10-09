class JobApplication < ApplicationRecord
  include AASM
  audited except: %i(files_count files_unread_count emails_count emails_administrator_unread_count emails_user_unread_count administrator_notifications_count)
  has_associated_audits

  include PgSearch
  pg_search_scope :search_full_text, against: [
    [:first_name, 'A'],
    [:last_name, 'A']
  ], associated_against: {
    job_offer: %i(identifier title)
  }

  belongs_to :job_offer
  belongs_to :user
  belongs_to :employer
  accepts_nested_attributes_for :user
  has_many :messages, dependent: :destroy
  has_many :emails, dependent: :destroy

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
  before_save :compute_notifications_counter

  FINISHED_STATES = %i(rejected phone_meeting_rejected after_meeting_rejected affected).freeze
  enum state: {
    initial: 0,
    rejected: 1,
    phone_meeting: 2,
    phone_meeting_rejected: 3,
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
      [:phone_meeting, :phone_meeting_rejected],
      [:to_be_met, :after_meeting_rejected],
      [:accepted],
      [:contract_drafting],
      [:contract_feedback_waiting],
      [:contract_received],
      [:affected]
    ]
  end

  def end_user_state_number
    self.class.end_user_states_regrouping.index { |x| x.include?(state.to_sym) } + 1
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
    column_name: 'job_applications_count',
    touch: true
  counter_culture :job_offer,
    column_name: :notifications_count,
    delta_column: 'administrator_notifications_count',
    touch: true

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

  def compute_notifications_counter!
    compute_notifications_counter
    save!
  end

  def compute_notifications_counter
    compute_files_count
    compute_emails_count
    compute_administrator_notifications_count
    true
  end

  def compute_files_count
    ary = JobOffer::FILES.inject([0, 0]) { |memo,obj|
      if self.send("#{obj}?".to_sym)
        memo[0] += 1
        if self.send("#{obj}_is_validated".to_sym) == 0
          memo[1] += 1
        end
      end
      memo
    }
    ary = User::FILES.inject(ary) { |memo,obj|
      if self.user.send("#{obj}?".to_sym)
        memo[0] += 1
        if self.user.send("#{obj}_is_validated".to_sym) == 0
          memo[1] += 1
        end
      end
      memo
    }
    self.files_count, self.files_unread_count = ary
  end

  def compute_emails_count
    ary = emails.reload.inject([0, 0]) do |memo,obj|
      if obj.is_unread?
        memo[0] += 1 if obj.sender.is_a?(User)
        memo[1] += 1 if obj.sender.is_a?(Administrator)
      end
      memo
    end
    self.emails_administrator_unread_count, self.emails_user_unread_count = ary
  end

  def compute_administrator_notifications_count
    self.administrator_notifications_count = self.emails_administrator_unread_count + self.files_unread_count
  end
end
