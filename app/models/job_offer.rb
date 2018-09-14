class JobOffer < ApplicationRecord
  SETTINGS = %i(category official_status contract_type study_level experience_level sector).freeze

  include AASM

  extend FriendlyId
  friendly_id :title, use: [:slugged, :finders, :history]

  acts_as_sequenced scope: :employer_id

  include PgSearch
  pg_search_scope :search_full_text, against: [
    [:identifier, 'A'],
    [:title, 'A'],
    [:description, 'B'],
    [:location, 'C']
  ], associated_against: SETTINGS.inject({}) { |memo, obj|
    memo[obj] = %i(name)
    memo
  }

  ## Relationships
  belongs_to :owner, class_name: 'Administrator'
  belongs_to :employer
  SETTINGS.each do |setting|
    belongs_to setting
  end

  has_many :job_applications

  ## Validations
  validates :title, :description, :contract_start_on, :duration_contract, presence: true

  ## Scopes
  scope :publicly_visible, -> { where(state: :published) }
  scope :search_import, -> { includes(*SETTINGS) }

  ## Enums
  OPTIONS_AVAILABLE = { disabled: 0, optional: 1, mandatory: 2 }
  FILES = %i(cover_letter resume photo).freeze
  URLS = %i(website_url linkedin_url).freeze
  (FILES + URLS).each do |opt_name|
    enum :"option_#{opt_name}" => OPTIONS_AVAILABLE, _suffix: true
  end

  enum most_advanced_job_applications_state: {
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

  enum state: {
    draft: 0,
    published: 1,
    suspended: 2,
    archived: 3
  }

  ## States and events
  aasm column: :state, enum: true do
    state :draft, initial: true
    state :published
    state :suspended
    state :archived

    event :publish do
      transitions from: [:draft], to: :published
    end

    event :draftize do
      transitions from: [:published], to: :draft
    end

    event :archive do
      transitions from: [:draft, :published, :suspended], to: :archived
    end

    event :suspend do
      transitions from: [:published], to: :suspended
    end

    event :unsuspend do
      transitions from: [:suspended], to: :published
    end

    event :unarchive do
      transitions from: [:archived], to: :draft
    end
  end

  ## Callbacks
  after_create :set_identifier
  after_validation :set_duration_without_cdd
  before_validation :hack_duration_require

  def set_identifier
    self.update_column :identifier, [employer.code, sequential_id].join('')
  end

  def hack_duration_require
    if (self.contract_type&.name != "CDD")
      self.duration_contract = "nop"
    end
  end

  def set_duration_without_cdd
    if (self.contract_type&.name != "CDD")
      self.duration_contract = nil
    end
  end
end
