# frozen_string_literal: true

# Recruiter on the platform
class Administrator < ApplicationRecord
  devise :database_authenticatable,
    :recoverable, :trackable, :validatable,
    :confirmable, :lockable, :timeoutable

  include DeactivationFlow

  #####################################
  # Relationships
  belongs_to :organization
  belongs_to :employer, optional: true
  validates :employer, presence: true, if: proc { |a| a.employer? || a.ensure_employer_is_set }
  belongs_to :inviter, optional: true, class_name: "Administrator"
  has_many :invitees, class_name: "Administrator", foreign_key: "inviter_id"

  has_many :owned_job_offers, class_name: "JobOffer", foreign_key: "owner_id"
  has_many :job_offer_actors
  has_many :job_offers, through: :job_offer_actors

  belongs_to :supervisor_administrator, optional: true, class_name: "Administrator"
  belongs_to :grand_employer_administrator, optional: true, class_name: "Administrator"

  accepts_nested_attributes_for :supervisor_administrator
  accepts_nested_attributes_for :grand_employer_administrator

  has_many :preferred_users
  has_many :preferred_users_lists

  def supervisor_administrator_attributes=(attributes)
    return if attributes[:email].blank?

    existing = Administrator.where(email: attributes[:email]).first
    if existing
      self.supervisor_administrator = existing
    else
      a = build_supervisor_administrator(attributes)
      a.organization = organization
      a.inviter = self
      a
    end
  end

  def grand_employer_administrator_attributes=(attributes)
    return if attributes[:email].blank?

    existing = Administrator.where(email: attributes[:email]).first
    if existing
      self.grand_employer_administrator = existing
    else
      a = build_grand_employer_administrator(attributes)
      a.organization = organization
      a.inviter = self
      a
    end
  end

  mount_uploader :photo, PhotoUploader, mount_on: :photo_file_name

  #####################################
  # Validations

  validates :photo,
    file_size: {less_than: 1.megabytes}
  validate :password_complexity
  validate :email_conformance
  validates :email, presence: true, uniqueness: true
  validates :employer, presence: true, if: proc { |a| %w[employer grand_employer].include?(a.role) }
  validates :inviter, presence: true, unless: proc { |a| a.very_first_account }, on: :create
  validates_inclusion_of :role,
    in: lambda { |a|
      if a.very_first_account
        a.class.roles.keys
      else
        (a.inviter&.authorized_roles_to_confer || a.class.roles.keys.last)
      end
    },
    allow_blank: true,
    message: :non_compliant_role,
    on: :create

  ####################################
  # Scope
  scope :active, -> { where(deleted_at: nil) }
  scope :inactive, -> { where.not(deleted_at: nil) }

  #####################################
  # Enums
  enum role: {
    bant: 0,
    employer: 1
  }

  attr_accessor :ensure_employer_is_set

  # ensure user account is active
  def active_for_authentication?
    super && !deleted_at
  end

  def password_required?
    # Password is required if it is being set, but not for new records
    if !persisted?
      false
    else
      !password.nil? || !password_confirmation.nil?
    end
  end

  def password_match?
    if password.blank?
      msg = I18n.t("errors.messages.blank")
      errors[:password] << msg
    end
    if password_confirmation.blank?
      msg = I18n.t("errors.messages.blank")
      errors[:password_confirmation] << msg
    end
    if password != password_confirmation
      msg = I18n.translate("errors.messages.confirmation", attribute: "password")
      errors[:password_confirmation] << msg
    end
    password == password_confirmation && !password.blank?
  end

  # new function to return whether a password has been set
  def no_password?
    encrypted_password.blank?
  end

  def confirmation_token_still_valid?
    return true unless confirmation_period_expired?

    errors.add(:base, :confirmation_period_expired,
      period: Devise::TimeInflector.time_ago_in_words(self.class.confirm_within.ago))
    false
  end

  # Devise::Models:unless_confirmed` method doesn't exist in Devise 2.0.0 anymore.
  # Instead you should use `pending_any_confirmation`.
  def only_if_unconfirmed(&block)
    pending_any_confirmation(&block)
  end

  # If global suffix is provided, we should not let admin be invited when their email is not suffixed correctly.
  # Adds a thin layer of security to force admin to invite only other admin with their official email address.
  def email_conformance
    suffix = organization.try(:administrator_email_suffix)
    suffix ||= ENV["ADMINISTRATOR_EMAIL_SUFFIX"]

    return if suffix.blank? || email.ends_with?(suffix)

    msg = I18n.t("activerecord.errors.messages.invalid_suffix", suffix: suffix)
    errors.add(:email, msg)
  end

  def full_name
    @full_name ||= begin
      if first_name.present? || last_name.present?
        [first_name, last_name].join(" ")
      else
        email
      end
    end
  end

  def full_name_with_title
    @full_name_with_title ||= begin
      if title.present? || first_name.present? || last_name.present?
        [title, first_name, last_name].join(" ")
      else
        email
      end
    end
  end

  def authorized_roles_to_confer
    if bant?
      self.class.roles.map(&:first)
    elsif employer?
      %w[employer]
    end
  end

  def transfer!(email)
    administrator = Administrator.find_by(email: email.downcase) || Administrator.new(email: email)
    administrator.inviter ||= self
    administrator.organization = organization
    administrator.save!
    job_offer_actors.update_all(administrator_id: administrator.id)
    owned_job_offers.update_all(owner_id: administrator.id)
  end

  def password_complexity
    # Regexp extracted from https://stackoverflow.com/questions/19605150/regex-for-password-must-contain-at-least-eight-characters-at-least-one-number-a
    regexp = /^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,70}$/
    return if password.blank? || password =~ regexp

    errors.add :password, :not_strong_enough
  end
end

# == Schema Information
#
# Table name: administrators
#
#  id                              :uuid             not null, primary key
#  confirmation_sent_at            :datetime
#  confirmation_token              :string
#  confirmed_at                    :datetime
#  current_sign_in_at              :datetime
#  current_sign_in_ip              :inet
#  deleted_at                      :datetime
#  email                           :string           default(""), not null
#  encrypted_password              :string           default(""), not null
#  failed_attempts                 :integer          default(0), not null
#  first_name                      :string
#  last_name                       :string
#  last_sign_in_at                 :datetime
#  last_sign_in_ip                 :inet
#  locked_at                       :datetime
#  marked_for_deactivation_on      :date
#  photo_content_type              :string
#  photo_file_name                 :string
#  photo_file_size                 :bigint
#  photo_updated_at                :datetime
#  reset_password_sent_at          :datetime
#  reset_password_token            :string
#  role                            :integer
#  sign_in_count                   :integer          default(0), not null
#  title                           :string
#  unconfirmed_email               :string
#  unlock_token                    :string
#  very_first_account              :boolean          default(FALSE)
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#  employer_id                     :uuid
#  grand_employer_administrator_id :uuid
#  inviter_id                      :uuid
#  organization_id                 :uuid
#  supervisor_administrator_id     :uuid
#
# Indexes
#
#  index_administrators_on_confirmation_token               (confirmation_token) UNIQUE
#  index_administrators_on_email                            (email) UNIQUE
#  index_administrators_on_employer_id                      (employer_id)
#  index_administrators_on_grand_employer_administrator_id  (grand_employer_administrator_id)
#  index_administrators_on_inviter_id                       (inviter_id)
#  index_administrators_on_organization_id                  (organization_id)
#  index_administrators_on_reset_password_token             (reset_password_token) UNIQUE
#  index_administrators_on_supervisor_administrator_id      (supervisor_administrator_id)
#  index_administrators_on_unlock_token                     (unlock_token) UNIQUE
#
# Foreign Keys
#
#  fk_rails_6ebddde259  (grand_employer_administrator_id => administrators.id)
#  fk_rails_92b1b055db  (supervisor_administrator_id => administrators.id)
#  fk_rails_cc9399b781  (employer_id => employers.id)
#  fk_rails_d10e15274b  (inviter_id => administrators.id)
#
