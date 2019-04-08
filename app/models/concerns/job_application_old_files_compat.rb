require 'active_support/concern'

module JobApplicationOldFilesCompat
  extend ActiveSupport::Concern

  included do
    %i(cover_letter resume).each do |field|
      mount_uploader field.to_sym, DocumentUploader, mount_on: :"old_#{field}_file_name"
    end
  end
end
