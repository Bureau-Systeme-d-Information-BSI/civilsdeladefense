# frozen_string_literal: true

class SecureContentJob < ApplicationJob
  queue_as :default

  def perform(id:)
    JobApplicationFile.find_by(id: id)&.secure_content!
  end
end
