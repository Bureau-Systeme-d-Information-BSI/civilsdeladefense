class Administrators::SessionsController < Devise::SessionsController
  after_action :remove_notice, only: :create # rubocop:disable Rails/LexicallyScopedActionFilter

  private

  def remove_notice = flash.discard(:notice)
end
