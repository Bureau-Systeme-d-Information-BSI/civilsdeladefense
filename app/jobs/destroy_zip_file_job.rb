# frozen_string_literal: true

class DestroyZipFileJob < ApplicationJob
  queue_as :default

  def perform(id:)
    ZipFile.find_by(id: id)&.destroy!
  end
end
