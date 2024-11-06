# frozen_string_literal: true

module Maintenance
  class PopulateResumesTask < MaintenanceTasks::Task
    include Rails.application.routes.url_helpers

    def collection = Profile.where(profileable_type: "User", resume_file_name: [nil, ""])

    def process(profile)
      return if profile.profileable.blank?

      job_application = profile.profileable.last_job_application
      return if job_application.blank?

      job_application_file_type = JobApplicationFileType.find_by(name: "CV")
      if job_application_file_type.blank?
        job_application_file = job_application.job_application_files.where(job_application_file_type: nil).first
      else
        job_application_file = job_application.job_application_files.find_by(job_application_file_type:)
        job_application_file ||= job_application.job_application_files.where(job_application_file_type: nil).first
      end
      return if job_application_file.blank?

      return if job_application_file.content_file_name.blank?
      return if job_application_file.document_content.blank?
      return unless job_application_file.content_file_name.ends_with?(".pdf")

      update_resume(profile, job_application_file)
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error("Error updating resume for profile #{profile.id}: #{e.message}")
    rescue => e
      Rails.logger.error("Something went wrong #{profile.id}: #{e.message}")
    end

    delegate :count, to: :collection

    private

    def update_resume(profile, job_application_file)
      file = Tempfile.new([job_application_file.content_file_name.gsub(".pdf", ""), ".pdf"])
      file.binmode
      file.write(job_application_file.document_content.read)
      file.rewind

      profile.update!(resume: file)

      file.close
      file.unlink
    end
  end
end
