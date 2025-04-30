# frozen_string_literal: true

# Candidacy to a job offer
class JobApplication < ApplicationRecord
  include Readable

  include AASM
  audited except: %i[files_count files_unread_count emails_count
    emails_administrator_unread_count emails_user_unread_count
    administrator_notifications_count
    skills_fit_job_offer experiences_fit_job_offer]
  has_associated_audits

  include PgSearch::Model
  pg_search_scope :search_full_text,
    against: [],
    ignoring: :accents,
    associated_against: {
      user: %i[first_name last_name],
      job_offer: %i[identifier title]
    }
  pg_search_scope :search_users,
    ignoring: :accents,
    associated_against: {
      user: %i[email first_name last_name]
    },
    using: {
      tsearch: {prefix: true, any_word: true}
    }

  belongs_to :job_offer
  belongs_to :organization
  belongs_to :user, optional: true
  accepts_nested_attributes_for :user
  belongs_to :rejection_reason, optional: true
  belongs_to :employer
  belongs_to :category, optional: true

  has_one :profile, through: :user

  has_many :messages, dependent: :destroy
  has_many :emails, dependent: :destroy
  has_many :job_application_files, index_errors: true, dependent: :destroy
  accepts_nested_attributes_for :job_application_files

  scope :with_category, -> { where.not(category: nil) }

  validates :user_id, uniqueness: {scope: :job_offer_id}, on: :create, allow_nil: true # rubocop:disable Rails/UniqueValidationWithoutIndex
  validate :missing_rejection_reason, if: -> { rejected && rejection_reason.blank? }
  validate :cant_accept_before_delay
  validate :complete_files_before_draft_contract
  validate :cant_be_accepted_twice, if: -> { accepted? }, unless: -> { has_accepted_other_job_application? }

  before_validation :set_employer
  before_save :compute_notifications_counter
  before_save :cleanup_rejection_reason, unless: -> { rejected }
  after_update :notify_new_state, if: -> { new_state_requires_notification? }
  after_update :notify_rejected, if: -> { rejected_state_requires_notification? }

  FINISHED_STATES = %w[rejected phone_meeting_rejected after_meeting_rejected affected].freeze
  REJECTED_STATES = %w[rejected phone_meeting_rejected after_meeting_rejected].freeze # Deprecated on 2025-04-30 (rejected states)
  PROCESSING_STATES = %w[initial phone_meeting to_be_met].freeze
  FILLED_STATES = %w[
    accepted contract_drafting contract_feedback_waiting contract_received affected
  ].freeze
  NOTIFICATION_STATES = %w[
    phone_meeting to_be_met accepted contract_drafting contract_feedback_waiting contract_received affected
  ].freeze

  enum state: {
    initial: 0,
    rejected: 1, # Deprecated on 2025-04-30 (rejected states)
    phone_meeting: 2,
    phone_meeting_rejected: 3, # Deprecated on 2025-04-30 (rejected states)
    to_be_met: 5,
    after_meeting_rejected: 6, # Deprecated on 2025-04-30 (rejected states)
    accepted: 7,
    contract_drafting: 8,
    contract_feedback_waiting: 9,
    contract_received: 10,
    affected: 11
  }

  aasm column: :state, enum: true do
    state :initial, initial: true
    state :rejected # Deprecated on 2025-04-30 (rejected states)
    state :phone_meeting,
      before_enter: proc { notify_new_state(:phone_meeting) }
    state :phone_meeting_rejected # Deprecated on 2025-04-30 (rejected states)
    state :to_be_met
    state :after_meeting_rejected # Deprecated on 2025-04-30 (rejected states)
    state :accepted
    state :contract_drafting
    state :contract_feedback_waiting
    state :contract_received
    state :affected

    event :reject do # Deprecated on 2025-04-30 (rejected states)
      transitions from: [:initial], to: :rejected
    end
  end

  def self.end_user_states_regrouping
    @end_user_states_regrouping ||= [
      %i[initial rejected],
      %i[phone_meeting phone_meeting_rejected],
      %i[to_be_met after_meeting_rejected],
      [:accepted],
      [:contract_drafting],
      [:contract_feedback_waiting],
      [:contract_received],
      [:affected]
    ]
  end

  STATE_DURATION = [
    [:initial, :rejected],
    [:initial, :phone_meeting],
    [:phone_meeting, :phone_meeting_rejected],
    [:phone_meeting, :to_be_met],
    [:to_be_met, :after_meeting_rejected],
    [:to_be_met, :accepted],
    [:accepted, :contract_drafting],
    [:contract_drafting, :contract_feedback_waiting],
    [:contract_feedback_waiting, :contract_received],
    [:contract_received, :affected]
  ]

  def self.state_durations_map(scope)
    Rails.cache.fetch(scope.to_sql, expires_in: 24.hours) do
      query_state_durations_map(scope)
    end
  end

  def self.query_state_durations_map(scope)
    STATE_DURATION.map { |from, to|
      from_state = states[from].to_s
      to_state = states[to].to_s
      days = scope
        .joins('INNER JOIN "audits" AS audits_start ON "audits_start"."auditable_type" = \'JobApplication\' AND "audits_start"."auditable_id" = "job_applications"."id"')
        .joins('INNER JOIN "audits" AS audits_end ON "audits_start"."auditable_type" = \'JobApplication\'
          AND "audits_end"."auditable_id" = "job_applications"."id"')
        .where("audits_start.audited_changes->?->-1 @> ?", :state, from_state)
        .where("audits_end.audited_changes->?->-1 @> ?", :state, to_state)
        .pluck(Arel.sql("DATE_PART('day', audits_end.created_at - audits_start.created_at)"))
      average = days.present? ? (days.reduce(:+) / days.size.to_f).round : "-"
      [from, to, average]
    }
  end

  def end_user_state_number
    self.class.end_user_states_regrouping.index { |x| x.include?(state.to_sym) } + 1
  end

  def end_user_state
    "end_user_state_#{end_user_state_number}"
  end

  counter_culture :job_offer,
    column_name: proc { |model| "#{model.state}_job_applications_count" },
    column_names: aasm.states.each_with_object({}) { |obj, memo|
                    state = obj.name
                    enum_value = states[state]
                    col_name = "#{state}_job_applications_count"
                    memo[["job_applications.state = ?", enum_value]] = col_name
                  },
    touch: true
  counter_culture :job_offer,
    column_name: "job_applications_count",
    touch: true
  counter_culture :job_offer,
    column_name: :notifications_count,
    delta_column: "administrator_notifications_count",
    touch: true
  counter_culture :user,
    column_name: "job_applications_count",
    touch: true

  default_scope { order(created_at: :desc) }
  scope :finished, -> { where(state: FINISHED_STATES) }
  scope :not_finished, -> { where.not(state: FINISHED_STATES) }
  scope :between, ->(a, b) { where(created_at: b..a) }
  scope :with_user, -> { where.not(user: nil) }

  def set_employer
    self.employer_id ||= job_offer.employer_id
  end

  def cleanup_rejection_reason
    self.rejection_reason = nil
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
    ary_start = [0, 0]
    ary = job_application_files.each_with_object(ary_start) { |job_application_file, memo|
      memo[0] += 1
      memo[1] += 1 if job_application_file.waiting_validation? && job_application_file.job_application_file_type&.notification
    }
    self.files_count, self.files_unread_count = ary
  end

  def compute_emails_count
    ary = emails.reload.each_with_object([0, 0]) { |obj, memo|
      if obj.is_unread?
        memo[0] += 1 if obj.sender.is_a?(User)
        memo[1] += 1 if obj.sender.is_a?(Administrator)
      end
    }
    self.emails_administrator_unread_count, self.emails_user_unread_count = ary
  end

  def compute_administrator_notifications_count
    self.administrator_notifications_count = emails_administrator_unread_count + files_unread_count
  end

  # Return two arrays
  # First with JobApplicationFile already existing or that need to be fill
  # Second with JobApplicationFileType where no instance exist in first array
  def files_to_be_provided
    result = {}
    result[:must_be_provided_files] = []
    result[:optional_file_types] = []

    JobApplicationFileType.all.find_each do |file_type|
      existing_file = job_application_files.detect { |file|
        file.job_application_file_type == file_type
      }

      from_state_as_val = JobApplication.states[file_type.from_state]
      current_state_as_val = JobApplication.states[state]

      if existing_file
        result[:must_be_provided_files] << existing_file
      elsif (current_state_as_val >= from_state_as_val) && file_type.by_default
        virgin = job_application_files.build(job_application_file_type: file_type)
        result[:must_be_provided_files] << virgin
      else
        result[:optional_file_types] << file_type
      end
    end

    result
  end

  def send_confirmation_email
    job_offer_identifier = job_offer.identifier
    service_name = job_offer.organization.service_name

    if job_offer.spontaneous
      subject = I18n.t(
        "job_offers.successful.spontaneous_subject", service_name: service_name
      )
      body = I18n.t(
        "job_offers.successful.spontaneous_body", service_name: service_name
      )
    else
      subject = I18n.t(
        "job_offers.successful.subject",
        job_offer_identifier: job_offer_identifier,
        service_name: service_name
      )
      body = I18n.t(
        "job_offers.successful.body",
        job_offer_title: job_offer.title,
        job_offer_identifier: job_offer_identifier,
        service_name: service_name
      )
    end

    email = emails.create(subject: subject, body: body)
    ApplicantNotificationsMailer.new_email(email.id).deliver_now
  end

  def rejected_state?
    REJECTED_STATES.include?(state)
  end

  def cant_accept_before_delay
    return if state.to_s != "accepted"
    return if state_was.to_s == "accepted"
    return if job_offer.csp_date.blank?
    return if job_offer.csp_date + 30.days < Time.zone.now

    errors.add(:state, :cant_accept_before_delay)
  end

  def complete_files_before_draft_contract
    return if state.to_s != "contract_drafting"

    default_types = JobApplicationFileType.by_default(:accepted).pluck(:id)
    validated_types = job_application_files.where(is_validated: true).pluck(:job_application_file_type_id)

    return if (default_types - validated_types).blank?

    errors.add(:state, :complete_files_before_draft_contract)
  end

  def cant_be_accepted_twice = errors.add(:state, :cant_be_accepted_twice)

  def has_accepted_other_job_application? = user.job_applications.where(state: "accepted").where.not(id: id).empty?

  def missing_rejection_reason = errors.add(:rejection_reason, :blank)

  def notify_new_state = ApplicantNotificationsMailer.with(user:, job_offer:, state:).notify_new_state.deliver_later

  def new_state_requires_notification? = saved_change_to_state? && NOTIFICATION_STATES.include?(state.to_s)

  def notify_rejected = ApplicantNotificationsMailer.with(user:, job_offer:).notify_rejected.deliver_later

  def rejected_state_requires_notification? = saved_change_to_state? && REJECTED_STATES.include?(state.to_s)

  class << self
    def rejected_states
      REJECTED_STATES
    end

    def processing_states
      PROCESSING_STATES
    end

    def selected_states
      states.keys - %w[initial rejected]
    end

    def phone_meeting_gt_states
      all_states_greater_than("phone_meeting")
    end

    def all_states_greater_than(state_name)
      JobApplication.states.each_with_object([]) do |(name, number), memo|
        memo << name if number > JobApplication.states[state_name]
      end
    end
  end
end

# == Schema Information
#
# Table name: job_applications
#
#  id                                :uuid             not null, primary key
#  administrator_notifications_count :integer          default(0)
#  emails_administrator_unread_count :integer          default(0)
#  emails_count                      :integer          default(0)
#  emails_unread_count               :integer          default(0)
#  emails_user_unread_count          :integer          default(0)
#  experiences_fit_job_offer         :boolean
#  files_count                       :integer          default(0)
#  files_unread_count                :integer          default(0)
#  rejected                          :boolean          default(FALSE)
#  skills_fit_job_offer              :boolean
#  state                             :integer
#  created_at                        :datetime         not null
#  updated_at                        :datetime         not null
#  category_id                       :uuid
#  employer_id                       :uuid
#  job_offer_id                      :uuid
#  organization_id                   :uuid
#  rejection_reason_id               :uuid
#  user_id                           :uuid
#
# Indexes
#
#  index_job_applications_on_category_id          (category_id)
#  index_job_applications_on_employer_id          (employer_id)
#  index_job_applications_on_job_offer_id         (job_offer_id)
#  index_job_applications_on_organization_id      (organization_id)
#  index_job_applications_on_rejection_reason_id  (rejection_reason_id)
#  index_job_applications_on_state                (state)
#  index_job_applications_on_user_id              (user_id)
#
# Foreign Keys
#
#  fk_rails_0e9ee51b69  (user_id => users.id)
#  fk_rails_36c9b0d626  (category_id => categories.id)
#  fk_rails_88b000fe87  (job_offer_id => job_offers.id)
#  fk_rails_e668fb8ac4  (employer_id => employers.id)
#  fk_rails_e73e1d195a  (rejection_reason_id => rejection_reasons.id)
#
