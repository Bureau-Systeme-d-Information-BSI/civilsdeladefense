# frozen_string_literal: true

# Candidacy to a job offer
class JobApplication < ApplicationRecord
  include AASM
  audited except: %i[files_count files_unread_count emails_count
    emails_administrator_unread_count emails_user_unread_count
    administrator_notifications_count
    skills_fit_job_offer experiences_fit_job_offer]
  has_associated_audits

  include PgSearch::Model
  pg_search_scope :search_full_text,
    against: [],
    associated_against: {
      user: %i[first_name last_name],
      job_offer: %i[identifier title]
    }

  belongs_to :job_offer
  belongs_to :organization
  belongs_to :user, optional: true
  belongs_to :rejection_reason, optional: true
  accepts_nested_attributes_for :user
  belongs_to :employer
  has_one :profile, as: :profileable, required: true
  accepts_nested_attributes_for :profile
  has_many :messages, dependent: :destroy
  has_many :emails, dependent: :destroy
  has_many :job_application_files, index_errors: true, dependent: :destroy
  accepts_nested_attributes_for :job_application_files

  has_many :job_application_actors
  has_many :actors,
    through: :job_applications_actors,
    class_name: "Administrator"

  validates :user_id, uniqueness: {scope: :job_offer_id}, on: :create, allow_nil: true

  before_validation :set_employer
  before_save :compute_notifications_counter
  before_save :cleanup_rejection_reason, unless: proc { |ja| ja.rejected? }

  FINISHED_STATES = %w[rejected phone_meeting_rejected after_meeting_rejected affected].freeze
  REJECTED_STATES = %w[rejected phone_meeting_rejected after_meeting_rejected].freeze
  PROCESSING_STATES = %w[initial phone_meeting to_be_met].freeze
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
      memo[1] += 1 if job_application_file.is_validated.zero? && job_application_file.job_application_file_type.notification
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

  def all_available_file_types
    @all_available_file_types ||= JobApplicationFileType.all.to_a
  end

  # Return two arrays
  # First with JobApplicationFile already existing
  # Second with JobApplicationFileType
  def files_to_be_provided
    JobApplicationFileType.all.each_with_object([[], []]) do |file_type, memo|
      existing_file = job_application_files.detect { |file|
        file.job_application_file_type == file_type
      }

      if existing_file
        memo.first << existing_file
      elsif file_type.is_mandatory?(state) && file_type.by_default
        virgin = job_application_files.build(job_application_file_type: file_type)
        memo.first << virgin
      else
        memo.last << file_type
      end
    end
  end

  def send_confirmation_email
    job_offer_identifier = job_offer.identifier
    service_name = job_offer.organization.service_name
    subject = I18n.t("job_offers.successful.subject", job_offer_identifier: job_offer_identifier,
                                                      service_name: service_name)
    body = I18n.t("job_offers.successful.body", first_name: user.first_name,
                                                job_offer_title: job_offer.title,
                                                job_offer_identifier: job_offer_identifier,
                                                service_name: service_name)
    email = emails.create(subject: subject, body: body)
    ApplicantNotificationsMailer.new_email(email.id).deliver_now
  end

  def rejected_state?
    REJECTED_STATES.include?(state)
  end

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
#  skills_fit_job_offer              :boolean
#  state                             :integer
#  created_at                        :datetime         not null
#  updated_at                        :datetime         not null
#  employer_id                       :uuid
#  job_offer_id                      :uuid
#  organization_id                   :uuid
#  rejection_reason_id               :uuid
#  user_id                           :uuid
#
# Indexes
#
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
#  fk_rails_88b000fe87  (job_offer_id => job_offers.id)
#  fk_rails_e668fb8ac4  (employer_id => employers.id)
#  fk_rails_e73e1d195a  (rejection_reason_id => rejection_reasons.id)
#
