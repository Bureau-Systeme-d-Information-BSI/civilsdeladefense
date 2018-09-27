class Administrator < ApplicationRecord
  devise :database_authenticatable,
         :recoverable, :trackable, :validatable,
         :confirmable, :lockable, :timeoutable

  #####################################
  # Relationships
  belongs_to :employer, optional: true
  belongs_to :inviter, optional: true, class_name: 'Administrator'
  has_many :job_offers, foreign_key: :owner
  has_attached_file :photo,
    styles: {
      small: "64x64#",
      medium: "80x80#",
      big: "160x160#"
    }
  validates_with AttachmentContentTypeValidator,
    attributes: :photo,
    content_type: /\Aimage\/.*\z/
  validates_with AttachmentSizeValidator,
    attributes: :photo,
    less_than: 1.megabyte

  #####################################
  # Validations
  validates :employer, presence: true, if: Proc.new { |a| a.role == 'employer' }
  validates :inviter, presence: true, unless: Proc.new { |a| a.very_first_account }, on: :create
  validates_inclusion_of :role,
    in: ->(a) {
      if a.very_first_account
        a.class.roles.keys
      else
        (a.inviter&.authorized_roles_to_confer || a.class.roles.keys.last)
      end
    },
    message: :non_compliant_role, on: :create

  #####################################
  # Enums
  enum role: {
    bant: 0,
    employer: 1,
    brh: 2
  }

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
    update_attributes(p)
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
    self.class.roles.inject([]) {|memo, (k,v)|
      memo << k if v >= score
      memo
    }
  end
end
