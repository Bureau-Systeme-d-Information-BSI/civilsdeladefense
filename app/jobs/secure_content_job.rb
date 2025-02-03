# frozen_string_literal: true

class SecureContentJob < ApplicationJob
  queue_as :default

  def perform(id:) = securable(id)&.secure_content!

  private

  def securable(id) = JobApplicationFile.find_by(id: id).presence || EmailAttachment.find_by(id: id)
end
