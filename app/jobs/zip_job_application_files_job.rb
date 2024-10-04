# frozen_string_literal: true

class ZipJobApplicationFilesJob < ApplicationJob
  queue_as :default

  def perform(zip_id:, user_ids:)
    zip_file = ZipFile.where(id: zip_id).first_or_create
    zip_file.zip = Pathname.new(Rails.root.join(zip(zip_id, user_ids, job_application_files(user_ids)))).open
    zip_file.save!
  end

  private

  def zip(zip_id, user_ids, job_application_files)
    File.open("tmp/#{zip_id}_e-recrutement_viviers.zip", "wb") { |f|
      compressed_filestream = Zip::OutputStream.write_buffer(f) { |zos|
        Profile.where(profileable_id: user_ids).select do |profile|
          profile.resume.present?
        end.each do |profile|
          zos.put_next_entry(resume_name(profile.profileable))
          zos << profile.resume.read
        end
        job_application_files.each do |job_application_file|
          next if job_application_file.document_content.blank?

          zos.put_next_entry(document_name(job_application_file))
          zos << job_application_file.document_content.read
        end
      }
      compressed_filestream.flush
    }.path
  end

  def resume_name(user)
    document = [
      user.full_name,
      "CV"
    ].join(" - ")
    "#{document}.pdf"
  end

  def document_name(job_application_file)
    document = [
      job_application_file.job_application.user.full_name,
      job_application_file.job_application_file_type.name
    ].join(" - ")
    "#{document}.pdf"
  end

  def job_application_files(user_ids)
    User.where(id: user_ids).map { |user|
      user.last_job_application
    }.select { |job_application|
      job_application.present?
    }.map { |job_application|
      job_application.job_application_files.select { |job_application_file|
        readable?(job_application_file)
      }
    }.flatten
  end

  def readable?(job_application_file)
    job_application_file.document_content.present? && job_application_file.document_content.read
  rescue NoMethodError
    false
  end
end
