class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable

  has_many :job_applications

  FILES_DURING_SUBMISSION = %i(photo resume cover_letter).freeze
  FILES_JUST_AFTER_SUBMISSION = %w(diploma identity carte_vitale_certificate proof_of_address medical_certificate iban transport_ticket).freeze
  FILES_FOR_PAYROLL = %w(contract agent_statement request_transport_costs request_family_supplement statement_sft).freeze
  FILES = (FILES_DURING_SUBMISSION + FILES_JUST_AFTER_SUBMISSION + FILES_FOR_PAYROLL).freeze
  FILES.each do |field|
    if field == :photo
      has_attached_file field.to_sym,
        styles: {
          small: "64x64#",
          medium: "80x80#",
          big: "160x160#"
        }
    else
      has_attached_file field.to_sym
    end
    validates_with AttachmentContentTypeValidator,
      attributes: field.to_sym,
      content_type: (field == :photo ? /\Aimage\/.*\z/ : "application/pdf")
    validates_with AttachmentSizeValidator,
      attributes: field.to_sym,
      less_than: (field == :photo ? 1.megabyte : 2.megabytes)
  end

  after_save :compute_job_applications_notifications_counter

  def compute_job_applications_notifications_counter
    job_applications.each &:compute_notifications_counter!
  end

  def full_name
    [first_name, last_name].join(" ")
  end
end
