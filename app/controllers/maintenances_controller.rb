class MaintenancesController < ActionController::Base # rubocop:disable Rails/ApplicationController
  layout "application"

  helper_method :current_organization

  def show
  end

  private

  def current_organization = @current_organization ||= Organization.first
end
