class User::MarkForDeletionJob < ApplicationJob
  queue_as :default

  def perform = User.mark_for_deletion
end
