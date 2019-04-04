require 'active_support/concern'

module JobApplicationOldFilesCompat
  extend ActiveSupport::Concern

  included do
    %i(cover_letter resume photo).each do |field|
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
      validates_presence_of field.to_sym,
        if: Proc.new { |job_application|
          job_application.job_offer.send("mandatory_option_#{field}?")
        }
    end
  end
end
