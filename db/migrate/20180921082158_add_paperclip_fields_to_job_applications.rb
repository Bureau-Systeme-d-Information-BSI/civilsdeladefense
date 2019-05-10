# frozen_string_literal: true

class AddPaperclipFieldsToJobApplications < ActiveRecord::Migration[5.2]
  def up
    JobOffer::FILES.each do |file|
      add_attachment :job_applications, file.to_sym
    end
    add_attachment :administrators, :photo
  end

  def down
    JobOffer::FILES.each do |file|
      remove_attachment :job_applications, file.to_sym
    end
    remove_attachment :administrators, :photo
  end
end
