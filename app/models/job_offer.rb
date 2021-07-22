# frozen_string_literal: true

# Represents a job proposed on the platform
class JobOffer < ApplicationRecord
  SETTINGS = %i[
    category contract_type experience_level professional_category sector study_level
  ].freeze

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
  pg_search_scope :search_full_text,
    ignoring: :accents,
    against: {
      identifier: "A",
      title: "A",
      description: "B",
      location: "C"
    },
    associated_against: SETTINGS.each_with_object({}) { |obj, memo|
      memo[obj] = %i[name]
    }

  ## Relationships
  belongs_to :owner, class_name: "Administrator"
  belongs_to :organization
  belongs_to :employer
  SETTINGS.each do |setting|
    belongs_to setting
  end
  belongs_to :contract_duration, optional: true
  belongs_to :bop, optional: true

  has_many :benefit_job_offers
  has_many :benefits, through: :benefit_job_offers

  has_many :job_applications, dependent: :destroy
  has_many :job_offer_actors, inverse_of: :job_offer, dependent: :destroy
  has_many :administrators, through: :job_offer_actors
  accepts_nested_attributes_for :job_offer_actors

  %i[employer grand_employer supervisor_employer brh].each do |actor_role|
    relationship1 = "job_offer_#{actor_role}_actors".to_sym
    relationship2 = "#{actor_role}_actors".to_sym
    has_many relationship1,
      -> { where(role: JobOfferActor.roles[actor_role]) },
      class_name: "JobOfferActor"
    has_many relationship2, through: relationship1, source: "administrator"
  end

  ## Validations
  validates :title, :description, :required_profile, :contract_start_on, presence: true
  validates :contract_duration_id, presence: true, if: -> { contract_type&.duration }
  validates :contract_duration_id, absence: true, unless: -> { contract_type&.duration }
  validates :title, format: {with: %r{\A.*F/H\z}, message: :f_h}
  validates :title, format: {without: %r{\A.*\(.*\z}, message: :brackets}
  validates :title, format: {without: %r{\A.*\).*\z}, message: :brackets}

  with_options if: -> { published? } do
    validates :title, length: {maximum: 70}
    validates :description, html_length: {maximum: 2000}
    validates :organization_description, html_length: {maximum: 1000}
    validates :required_profile, html_length: {maximum: 1000}
    validates :recruitment_process, html_length: {maximum: 700}
  end

  validate :pep_or_bne
  validates :pep_date, presence: true, if: -> { pep_value.present? }
  validates :bne_date, presence: true, if: -> { bne_value.present? }

  def pep_or_bne
    return if pep_value.present? || bne_value.present?

    errors.add(:base, :pep_or_bne)
  end

  ## Scopes
  default_scope { order(created_at: :desc) }
  scope :admin_index, -> { includes(:bop, :contract_type, :employer, :job_offer_actors) }
  scope :admin_index_active, -> { admin_index.where.not(state: :archived) }
  scope :admin_index_archived, -> { admin_index.archived }
  scope :admin_index_featured, -> { admin_index.where(featured: true) }
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
    state :draft, initial: true, before_enter: :set_timestamp
    state :published, before_enter: :set_timestamp
    state :suspended, before_enter: :set_timestamp
    state :archived, before_enter: :set_timestamp

    event :publish do
      transitions from: [:draft], to: :published, guard: :delay_before_publishing_over?
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

  # Return an hash where keys are regions and values are counties inside it
  # All regions and counties got job_offers associated
  def self.regions
    job_with_regions_and_county = unscoped.where.not(region: ["", nil]).where.not(county: ["", nil])
    hash_region_county = job_with_regions_and_county.select(:region, :county).distinct.pluck(:region, :county)
    hash_region_county.group_by { |a, b| a }.each_with_object({}) { |(key, values), hash|
      hash[key] = values.flatten - [key]
    }
  end

  def delay_before_publishing_over?
    delay = organization&.hours_delay_before_publishing
    if published_at.present?
      true
    elsif delay.blank? || delay.zero?
      true
    elsif created_at.nil?
      false
    else
      Time.zone.now > (created_at + delay.hours)
    end
  end

  def publishing_possible_at
    created_at + (organization.hours_delay_before_publishing || 0).hours
  end

  def state_date
    send("#{state}_at") if respond_to?("#{state}_at")
  end

  def set_timestamp
    to = aasm.to_state
    return unless respond_to?("#{to}_at=")

    send("#{to}_at=", Time.zone.now)
  end

  def self.new_from_scratch(reference_administrator)
    j = new
    j.contract_start_on = 6.months.from_now
    organization = reference_administrator.organization
    organization.organization_defaults.each do |organization_default|
      field = organization_default.kind.gsub("job_offer_", "")
      value = organization_default.value
      j.send("#{field}=", value)
    end
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
    update_column :identifier, [employer.code, sequential_id].join("")
  end

  def update_category_counter
    category.self_and_ancestors.reverse.each(&:compute_published_job_offers_count!)
  end

  def contract_type_is_cdd?
    contract_type&.name == "CDD"
  end

  def compute_notifications_count!
    compute_notifications_count
    save!
  end

  def compute_notifications_count
    self.notifications_count = job_applications.sum(:emails_administrator_unread_count) +
      job_applications.sum(:files_unread_count)
  end

  def cleanup_actor_administrator_dep(inviter, inviter_org)
    job_offer_actors.each do |job_offer_actor|
      if job_offer_actor.administrator
        job_offer_actor.administrator.inviter ||= inviter
        job_offer_actor.administrator.organization ||= inviter_org
      end
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

  def transfer(email, current_administrator)
    administrator = Administrator.find_by(email: email.downcase) || Administrator.new(email: email)
    administrator.inviter ||= current_administrator
    administrator.organization = current_administrator.organization
    administrator.save!
    job_offer_actors.where(administrator: owner).update_all(administrator_id: administrator.id)
    update!(owner: administrator)
  end

  def benefit
    benefits.pluck(:name).join(", ")
  end

  def send_to_users(users)
    users.each do |user|
      ApplicantNotificationsMailer.send_job_offer(user, self).deliver_now
    end
  end
end

# == Schema Information
#
# Table name: job_offers
#
#  id                                               :uuid             not null, primary key
#  accepted_job_applications_count                  :integer          default(0), not null
#  affected_job_applications_count                  :integer          default(0), not null
#  after_meeting_rejected_job_applications_count    :integer          default(0), not null
#  archived_at                                      :datetime
#  available_immediately                            :boolean          default(FALSE)
#  bne_date                                         :date
#  bne_value                                        :string
#  city                                             :string
#  contract_drafting_job_applications_count         :integer          default(0), not null
#  contract_feedback_waiting_job_applications_count :integer          default(0), not null
#  contract_received_job_applications_count         :integer          default(0), not null
#  contract_start_on                                :date             not null
#  country_code                                     :string
#  county                                           :string
#  county_code                                      :integer
#  description                                      :text
#  draft_at                                         :datetime
#  duration_contract                                :string
#  estimate_annual_salary_gross                     :string
#  estimate_monthly_salary_net                      :string
#  featured                                         :boolean          default(FALSE)
#  identifier                                       :string
#  initial_job_applications_count                   :integer          default(0), not null
#  is_remote_possible                               :boolean
#  job_applications_count                           :integer          default(0), not null
#  location                                         :string
#  most_advanced_job_applications_state             :integer          default("start")
#  notifications_count                              :integer          default(0)
#  option_photo                                     :integer
#  organization_description                         :text
#  pep_date                                         :date
#  pep_value                                        :string
#  phone_meeting_job_applications_count             :integer          default(0), not null
#  phone_meeting_rejected_job_applications_count    :integer          default(0), not null
#  postcode                                         :string
#  published_at                                     :datetime
#  recruitment_process                              :text
#  region                                           :string
#  rejected_job_applications_count                  :integer          default(0), not null
#  required_profile                                 :text
#  slug                                             :string           not null
#  spontaneous                                      :boolean          default(FALSE)
#  state                                            :integer
#  suspended_at                                     :datetime
#  title                                            :string
#  to_be_met_job_applications_count                 :integer          default(0), not null
#  created_at                                       :datetime         not null
#  updated_at                                       :datetime         not null
#  bop_id                                           :uuid
#  category_id                                      :uuid
#  contract_duration_id                             :uuid
#  contract_type_id                                 :uuid
#  employer_id                                      :uuid
#  experience_level_id                              :uuid
#  organization_id                                  :uuid
#  owner_id                                         :uuid
#  professional_category_id                         :uuid
#  sector_id                                        :uuid
#  sequential_id                                    :integer
#  study_level_id                                   :uuid
#
# Indexes
#
#  index_job_offers_on_bop_id                    (bop_id)
#  index_job_offers_on_category_id               (category_id)
#  index_job_offers_on_contract_duration_id      (contract_duration_id)
#  index_job_offers_on_contract_type_id          (contract_type_id)
#  index_job_offers_on_employer_id               (employer_id)
#  index_job_offers_on_experience_level_id       (experience_level_id)
#  index_job_offers_on_identifier                (identifier) UNIQUE
#  index_job_offers_on_organization_id           (organization_id)
#  index_job_offers_on_owner_id                  (owner_id)
#  index_job_offers_on_professional_category_id  (professional_category_id)
#  index_job_offers_on_sector_id                 (sector_id)
#  index_job_offers_on_slug                      (slug) UNIQUE
#  index_job_offers_on_state                     (state)
#  index_job_offers_on_study_level_id            (study_level_id)
#
# Foreign Keys
#
#  fk_rails_1d6fc1ac2d  (professional_category_id => professional_categories.id)
#  fk_rails_1db997256c  (experience_level_id => experience_levels.id)
#  fk_rails_2e21ee1517  (study_level_id => study_levels.id)
#  fk_rails_39bc76a4ec  (contract_type_id => contract_types.id)
#  fk_rails_3afb853ff8  (bop_id => bops.id)
#  fk_rails_578c30296c  (category_id => categories.id)
#  fk_rails_5aaea6c8db  (employer_id => employers.id)
#  fk_rails_6cf1ead2e5  (owner_id => administrators.id)
#  fk_rails_ee7a101e4f  (sector_id => sectors.id)
#
