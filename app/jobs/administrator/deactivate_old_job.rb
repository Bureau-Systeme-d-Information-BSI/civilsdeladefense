class Administrator::DeactivateOldJob < ApplicationJob
  queue_as :default

  def perform = Administrator.deactivate_when_too_old!
end
