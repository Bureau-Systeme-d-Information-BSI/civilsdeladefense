class Administrator < ApplicationRecord
  devise :database_authenticatable,
         :recoverable, :trackable, :validatable,
         :confirmable, :lockable, :timeoutable

  #####################################
  # Relationships
  belongs_to :employer, optional: true
  validates :employer, presence: true, if: Proc.new { |a| a.employer? || a.ensure_employer_is_set }
  belongs_to :inviter, optional: true, class_name: 'Administrator'
  has_many :invitees, class_name: 'Administrator', foreign_key: 'inviter_id'

  has_many :owned_job_offers, class_name: 'JobOffer', foreign_key: 'owner_id'
  has_many :job_offer_actors
  has_many :job_offers, through: :job_offer_actors

  belongs_to :supervisor_administrator, optional: true, class_name: 'Administrator'
  belongs_to :grand_employer_administrator, optional: true, class_name: 'Administrator'

  accepts_nested_attributes_for :supervisor_administrator
  accepts_nested_attributes_for :grand_employer_administrator

  has_many :job_application_actors
  has_many :job_applications, through: :job_applications_actors

  def supervisor_administrator_attributes=(attributes)
    if attributes[:email].present?
      existing = Administrator.where(email: attributes[:email]).first
      if existing
        supervisor_administrator = existing
      else
        a = build_supervisor_administrator(attributes)
        a.inviter = self
        a
      end
    end
  end

  def grand_employer_administrator_attributes=(attributes)
    if attributes[:email].present?
      existing = Administrator.where(email: attributes[:email]).first
      if existing
        self.grand_employer_administrator = existing
      else
        a = build_grand_employer_administrator(attributes)
        a.inviter = self
        a
      end
    end
  end

  mount_uploader :photo, PhotoUploader, mount_on: :photo_file_name

  #####################################
  # Validations

  validates :photo,
    file_size: { less_than: 1.megabytes }
  validate :password_complexity
  validate :email_conformance
  validates :employer, presence: true, if: Proc.new { |a| %w(employer grand_employer).include?(a.role) }
  validates :inviter, presence: true, unless: Proc.new { |a| a.very_first_account }, on: :create
  validates_inclusion_of :role,
    in: ->(a) {
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

  def password_required?
    # Password is required if it is being set, but not for new records
    if !persisted?
      false
    else
      !password.nil? || !password_confirmation.nil?
    end
  end

  def password_match?
     self.errors[:password] << I18n.t('errors.messages.blank') if password.blank?
     self.errors[:password_confirmation] << I18n.t('errors.messages.blank') if password_confirmation.blank?
     self.errors[:password_confirmation] << I18n.translate("errors.messages.confirmation", attribute: "password") if password != password_confirmation
     password == password_confirmation && !password.blank?
  end

  # new function to return whether a password has been set
  def has_no_password?
    self.encrypted_password.blank?
  end

  # Devise::Models:unless_confirmed` method doesn't exist in Devise 2.0.0 anymore.
  # Instead you should use `pending_any_confirmation`.
  def only_if_unconfirmed
    pending_any_confirmation {yield}
  end

  def email_conformance
    suffix = ENV['ADMINISTRATOR_EMAIL_SUFFIX']
    if suffix.present? && !(email.ends_with?(suffix))
      error_i18n = I18n.t('activerecord.errors.messages.invalid_suffix', suffix: ENV['ADMINISTRATOR_EMAIL_SUFFIX'])
      errors.add(:email, error_i18n)
    end
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
    score = self.role_before_type_cast
    if bant?
      self.class.roles.map(&:first)
    elsif employer?
      %w(employer)
    end
  end

  def active?
    deleted_at.blank?
  end

  def inactive?
    deleted_at.present?
  end

  def deactivate
    update_attribute(:deleted_at, Time.current)
  end

  def reactivate
    update_attribute(:deleted_at, nil)
  end

  def password_complexity
    # Regexp extracted from https://stackoverflow.com/questions/19605150/regex-for-password-must-contain-at-least-eight-characters-at-least-one-number-a
    return if password.blank? || password =~ /^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,70}$/

    errors.add :password, :not_strong_enough
  end
end
