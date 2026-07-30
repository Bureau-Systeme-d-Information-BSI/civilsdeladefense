class Administrator::DeletionJob < ApplicationJob
  queue_as :default

  def perform = Administrator.deletables.find_each(&:destroy_and_notify!)
end
