class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable

  has_many :job_applications

  FILES = %i(photo resume cover_letter diploma identity carte_vitale_certificate home_invoice medical_certificate contract iban agent_statement request_transport_costs request_family_supplement statement_sft).freeze
  FILES_ALWAYS = %i(resume cover_letter diploma identity carte_vitale_certificate home_invoice medical_certificate).freeze
  FILES_FOR_PAYROLL = (FILES - FILES_ALWAYS).freeze
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

  def full_name
    [first_name, last_name].join(" ")
  end
end
