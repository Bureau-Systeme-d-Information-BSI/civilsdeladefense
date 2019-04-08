class JobOffer < ApplicationRecord
  SETTINGS = %i(category professional_category contract_type study_level experience_level sector).freeze

  include AASM
  audited
  has_associated_audits

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

  has_many :job_offer_actors, inverse_of: :job_offer
  has_many :administrators, through: :job_offer_actors
  accepts_nested_attributes_for :job_offer_actors

  %i(employer grand_employer supervisor_employer brh).each do |actor_role|
    relationship_1 = "job_offer_#{actor_role}_actors".to_sym
    relationship_2 = "#{actor_role}_actors".to_sym
    has_many relationship_1, -> { where(role: JobOfferActor.roles[actor_role]) }, class_name: 'JobOfferActor'
    has_many relationship_2, through: relationship_1, source: 'administrator'
  end

  ## Validations
  validates :title, :description, :required_profile, :contract_start_on, presence: true
  validates :duration_contract, presence: true, if: :contract_type_is_cdd?
  validates :duration_contract, absence: true, unless: :contract_type_is_cdd?

  ## Scopes
  scope :publicly_visible, -> { where(state: :published) }
  scope :search_import, -> { includes(*SETTINGS) }

  enum most_advanced_job_applications_state: {
    start: -1,
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
      transitions from: [:published, :suspended], to: :suspended
    end

    event :unsuspend do
      transitions from: [:suspended], to: :published
    end

    event :unarchive do
      transitions from: [:archived, :draft], to: :draft
    end
  end

  ## Callbacks
  after_create :set_identifier
  after_save :update_category_counter

  def set_identifier
    self.update_column :identifier, [employer.code, sequential_id].join('')
  end

  def update_category_counter
    category.self_and_ancestors.reverse.each do |cat|
      cat.compute_published_job_offers_count!
    end
  end

  def contract_type_is_cdd?
    self.contract_type&.name == "CDD"
  end

  def compute_notifications_count!
    compute_notifications_count
    save!
  end

  def compute_notifications_count
    self.notifications_count = job_applications.sum(:emails_administrator_unread_count) + job_applications.sum(:files_unread_count)
  end
end
