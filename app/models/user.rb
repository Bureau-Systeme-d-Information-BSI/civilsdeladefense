class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable

  has_many :job_applications, dependent: :destroy

  FILES_DURING_SUBMISSION = %i(photo resume cover_letter).freeze
  FILES_JUST_AFTER_SUBMISSION = %w(diploma identity carte_vitale_certificate proof_of_address medical_certificate iban transport_ticket).freeze
  FILES_FOR_PAYROLL = %w(contract agent_statement request_transport_costs request_family_supplement statement_sft).freeze
  FILES = (FILES_DURING_SUBMISSION + FILES_JUST_AFTER_SUBMISSION + FILES_FOR_PAYROLL).freeze
  FILES.each do |field|
    if field == :photo
      mount_uploader :photo, PhotoUploader, mount_on: :photo_file_name
      validates :photo,
        file_size: { less_than: 1.megabytes },
        file_content_type: { allow: /^image\/.*/ }
    else
      mount_uploader field.to_sym, DocumentUploader, mount_on: :"#{field}_file_name"
      validates field.to_sym,
        file_size: { less_than: 2.megabytes },
        file_content_type: { allow: 'application/pdf' }
    end
  end

  validate :password_complexity

  after_save :compute_job_applications_notifications_counter

  def compute_job_applications_notifications_counter
    job_applications.each &:compute_notifications_counter!
  end

  def full_name
    [first_name, last_name].join(" ")
  end

  def password_complexity
    # Regexp extracted from https://stackoverflow.com/questions/19605150/regex-for-password-must-contain-at-least-eight-characters-at-least-one-number-a
    return if password.blank? || password =~ /^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,70}$/

    errors.add :password, :not_strong_enough
  end
end
