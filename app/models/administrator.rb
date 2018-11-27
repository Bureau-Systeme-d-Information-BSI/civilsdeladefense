class Administrator < ApplicationRecord
  devise :database_authenticatable,
         :recoverable, :trackable, :validatable,
         :confirmable, :lockable, :timeoutable

  #####################################
  # Relationships
  belongs_to :employer, optional: true
  belongs_to :inviter, optional: true, class_name: 'Administrator'
  has_many :invitees, class_name: 'Administrator'
  has_many :job_offers, foreign_key: :owner
  has_attached_file :photo,
    styles: {
      small: "64x64#",
      medium: "80x80#",
      big: "160x160#"
    }

  #####################################
  # Validations

  validates_with AttachmentContentTypeValidator,
    attributes: :photo,
    content_type: /\Aimage\/.*\z/
  validates_with AttachmentSizeValidator,
    attributes: :photo,
    less_than: 1.megabyte
  validate :password_complexity
  validate :email_conformance
  validates :employer, presence: true, if: Proc.new { |a| %w(employer grand_employer brh).include?(a.role) }
  validates :inviter, presence: true, unless: Proc.new { |a| a.very_first_account }, on: :create
  validates :email_brh, :email_grand_employer,
    presence: true,
    format: {with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i},
    if: Proc.new { |a|
      a.employer? && a.confirmation_account_process.present?
    }
  validate :email_grand_employer_brh_conformance
  validates_inclusion_of :role,
    in: ->(a) {
      if a.very_first_account
        a.class.roles.keys
      else
        (a.inviter&.authorized_roles_to_confer || a.class.roles.keys.last)
      end
    },
    message: :non_compliant_role, on: :create

  ####################################
  # Scope
  scope :active, -> { where(deleted_at: nil) }
  scope :inactive, -> { where.not(deleted_at: nil) }

  #####################################
  # Enums
  enum role: {
    bant: 0,
    employer: 1,
    brh: 2,
    grand_employer: 3
  }

  attr_accessor :confirmation_account_process, :email_grand_employer, :email_brh

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

  # new function to set the password without knowing the current
  # password used in our confirmation controller.
  def attempt_set_password(params)
    p = {}
    p[:password] = params[:password]
    p[:password_confirmation] = params[:password_confirmation]
    p[:first_name] = params[:first_name]
    p[:last_name] = params[:last_name]
    p[:email_brh] = params[:email_brh]
    p[:email_grand_employer] = params[:email_grand_employer]
    p[:confirmation_account_process] = params[:confirmation_account_process]
    update_attributes(p) and create_administrator_brh and create_admin_grand_employer
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

  def email_grand_employer_brh_conformance
    suffix = ENV['ADMINISTRATOR_EMAIL_SUFFIX']
    if suffix.present?
      if self.employer? && self.confirmation_account_process.present?
        if !(email_brh.ends_with?(suffix))
          error_i18n = I18n.t('activerecord.errors.messages.invalid_suffix', suffix: ENV['ADMINISTRATOR_EMAIL_SUFFIX'])
          errors.add(:email_brh, error_i18n)
        end
          if !(email_grand_employer.ends_with?(suffix))
          error_i18n = I18n.t('activerecord.errors.messages.invalid_suffix', suffix: ENV['ADMINISTRATOR_EMAIL_SUFFIX'])
          errors.add(:email_grand_employer, error_i18n)
        end
      end
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
      %w(brh employer grand_employer)
    elsif brh?
      %w(brh)
    elsif grand_employer?
      %w(grand_employer)
    end
  end

  def deactivate
    update_attribute(:deleted_at, Time.current)
  end

  def password_complexity
    # Regexp extracted from https://stackoverflow.com/questions/19605150/regex-for-password-must-contain-at-least-eight-characters-at-least-one-number-a
    return if password.blank? || password =~ /^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,70}$/

    errors.add :password, :not_strong_enough
  end

  def create_admin_grand_employer
    if email_grand_employer.present?
      existing = Administrator.find_by_email email_grand_employer
      grand_employer = self.employer.parent
      if !existing && grand_employer.present?
        administrator_grand_employer = Administrator.new do |a|
          a.inviter = self
          a.email = self.email_grand_employer
          a.role = 'grand_employer'
          a.employer = grand_employer
        end
        administrator_grand_employer.save!
      end
    end
  end

  def create_administrator_brh
    if email_brh.present?
      existing = Administrator.find_by_email email_brh
      if !existing
        administrator_brh = Administrator.new do |a|
          a.inviter = self
          a.email = self.email_brh
          a.role = 'brh'
          a.employer = self.employer
        end
        administrator_brh.save!
      end
    end
  end
end
