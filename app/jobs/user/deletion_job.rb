class User::DeletionJob < ApplicationJob
  queue_as :default

  def perform = User.deletables.find_each(&:destroy_and_notify!)
end
