class User::DeleteOldJob < ApplicationJob
  queue_as :default

  def perform = User.destroy_when_too_old
end
