# frozen_string_literal: true

# Represents a job proposed on the platform
class JobOffer < ApplicationRecord
  SETTINGS = %i[category contract_type experience_level professional_category
                sector study_level].freeze

  include JobOfferStateTimestamp
  include AASM
  audited
  has_associated_audits

  extend FriendlyId
  friendly_id :title, use: %i[slugged finders history]

  ## Callbacks
  before_save :unset_sequential_id, if: -> { employer_id_changed? }
  after_save :set_identifier, if: -> { saved_change_to_employer_id? }
  after_save :update_category_counter
  acts_as_sequenced scope: :employer_id

  include PgSearch::Model
  pg_search_scope :search_full_text, against: [
    [:identifier, 'A'],
    [:title, 'A'],
    [:description, 'B'],
    [:location, 'C']
  ], associated_against: SETTINGS.each_with_object({}) { |obj, memo|
    memo[obj] = %i[name]
  }

  ## Relationships
  belongs_to :owner, class_name: 'Administrator'
  belongs_to :organization
  belongs_to :employer
  SETTINGS.each do |setting|
    belongs_to setting
  end
  belongs_to :benefit, optional: true
  belongs_to :bop, optional: true

  has_many :job_applications
  has_many :job_offer_actors, inverse_of: :job_offer
  has_many :administrators, through: :job_offer_actors
  accepts_nested_attributes_for :job_offer_actors

  %i[employer grand_employer supervisor_employer brh].each do |actor_role|
    relationship1 = "job_offer_#{actor_role}_actors".to_sym
    relationship2 = "#{actor_role}_actors".to_sym
    has_many relationship1,
             -> { where(role: JobOfferActor.roles[actor_role]) },
             class_name: 'JobOfferActor'
    has_many relationship2, through: relationship1, source: 'administrator'
  end

  ## Validations
  validates :title, :description, :required_profile, :contract_start_on, presence: true
  validates :duration_contract, presence: true, if: :contract_type_is_cdd?
  validates :duration_contract, absence: true, unless: :contract_type_is_cdd?

  ## Scopes
  default_scope { order(created_at: :desc) }
  scope :admin_index, -> { includes(:bop, :contract_type, :employer, :job_offer_actors) }
  scope :admin_index_active, -> { admin_index.where.not(state: :archived) }
  scope :admin_index_archived, -> { admin_index.archived }
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
    state :published, before_enter: :set_timestamp
    state :suspended, before_enter: :set_timestamp
    state :archived, before_enter: :set_timestamp

    event :publish do
      transitions from: [:draft], to: :published
    end

    event :draftize do
      transitions from: [:published], to: :draft
    end

    event :archive do
      transitions from: %i[published suspended], to: :archived
    end

    event :suspend do
      transitions from: %i[published suspended], to: :suspended
    end

    event :unsuspend do
      transitions from: [:suspended], to: :published
    end

    event :unarchive do
      transitions from: %i[archived], to: :draft
    end
  end

  def self.new_from_scratch(reference_administrator)
    j = new
    j.contract_start_on = 6.months.from_now
    j.recruitment_process = I18n.t('default_recruitment_process')
    j.job_offer_actors.build(role: :employer).administrator = reference_administrator
    grand_employer_administrator = reference_administrator.grand_employer_administrator
    if grand_employer_administrator.present?
      j.job_offer_actors.build(role: :grand_employer).administrator = grand_employer_administrator
    end
    supervisor_administrator = reference_administrator.supervisor_administrator
    if supervisor_administrator.present?
      j.job_offer_actors.build(role: :supervisor_employer).administrator = supervisor_administrator
    end
    j
  end

  def self.new_from_source(source_id)
    return nil if source_id.blank?

    source = find(source_id)
    j = source.dup
    j.title = "Copie de #{j.title}"
    j.state = nil
    j
  end

  def unset_sequential_id
    self.sequential_id = nil
  end

  def set_identifier
    update_column :identifier, [employer.code, sequential_id].join('')
  end

  def update_category_counter
    category.self_and_ancestors.reverse.each(&:compute_published_job_offers_count!)
  end

  def contract_type_is_cdd?
    contract_type&.name == 'CDD'
  end

  def compute_notifications_count!
    compute_notifications_count
    save!
  end

  def compute_notifications_count
    self.notifications_count = job_applications.sum(:emails_administrator_unread_count) +
                               job_applications.sum(:files_unread_count)
  end

  def cleanup_actor_administrator_inviter(inviter)
    job_offer_actors.each do |job_offer_actor|
      job_offer_actor.administrator.inviter ||= inviter if job_offer_actor.administrator
    end
  end

  def current_most_advanced_job_applications_state
    ary = job_applications.select(:state, :created_at).group(:state, :created_at)
    ary.map(&:state_before_type_cast).max
  end

  def most_advanced_job_applications_state_as_number
    state = most_advanced_job_applications_state.to_sym
    JobApplication.aasm.states.index { |x| x.name == state }
  end

  def possible_events
    @possible_events ||= begin
      aasm.events.each_with_object([]) do |event, memo|
        event_name = event.name.to_s
        memo << event_name unless state.starts_with?(event_name)
      end
    end
  end
end
