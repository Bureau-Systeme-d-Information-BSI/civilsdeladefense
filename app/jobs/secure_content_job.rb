# frozen_string_literal: true

class SecureContentJob < ApplicationJob
  queue_as :default

  def perform(id:)
    securable(id)&.secure_content!
  rescue # if image magick fails because the image quality is to high, try again with lower density
    securable(id)&.secure_content!(density: 150)
  end

  private

  def securable(id)
    JobApplicationFile.find_by(id: id).presence || EmailAttachment.find_by(id: id)
  end
end
