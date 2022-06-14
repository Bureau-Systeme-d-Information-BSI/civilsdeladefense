# frozen_string_literal: true

class ZipJobApplicationFilesJob < ApplicationJob
  queue_as :default

  def perform(zip_id:, user_ids:)
    zip_file = ZipFile.create!(id: zip_id)
    zip_file.zip = Pathname.new(Rails.root.join(zip(zip_id, job_application_files(user_ids)))).open
    zip_file.save!
  end

  private

  def zip(zip_id, job_application_files)
    File.open("tmp/#{zip_id}_e-recrutement_viviers.zip", "wb") { |f|
      compressed_filestream = Zip::OutputStream.write_buffer(f) { |zos|
        job_application_files.each do |job_application_file|
          zos.put_next_entry(document_name(job_application_file))
          zos << job_application_file.content.read
        end
      }
      compressed_filestream.flush
    }.path
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
        job_application_file.content.present?
      }
    }.flatten
  end
end
