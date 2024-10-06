# frozen_string_literal: true

module Maintenance
  class RemoveResumeJobApplicationFileTypeTask < MaintenanceTasks::Task
    def collection = JobApplicationFileType.unscoped.where(name: "CV")

    def process(job_application_file_type) = job_application_file_type.destroy!

    delegate :count, to: :collection
  end
end
