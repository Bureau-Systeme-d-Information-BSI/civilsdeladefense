class Administrator::MarkForDeletionJob < ApplicationJob
  queue_as :default

  def perform = Administrator.long_time_unauthenticated.find_each(&:mark_for_deletion!)
end
