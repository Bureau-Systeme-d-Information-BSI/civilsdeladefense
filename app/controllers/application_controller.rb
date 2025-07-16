# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :redirect_permanently, if: -> { redirect_url.present? }
  before_action :redirect_to_maintenance_mode, if: :maintenance_mode_activated?, unless: :admin_secret_access?
  before_action :basic_auth, if: -> { ENV["BASIC_AUTH"].present? }

  layout :layout_by_resource

  include ErrorResponseActions
  include ErrorContextable
  include Timeoutable
  include Turbo::Redirection

  rescue_from CanCan::AccessDenied, with: :authorization_error
  rescue_from ActiveRecord::RecordNotFound, with: :resource_not_found
  rescue_from JobOfferNotAvailableAnymore, with: :resource_not_available_anymore
  rescue_from ForbiddenState, with: :bad_request

  helper_method :current_organization

  private

  def redirect_permanently = redirect_to redirect_url, allow_other_host: true, status: :moved_permanently

  def redirect_url = ENV["PERMANENTLY_REDIRECT_URL"]

  def redirect_to_maintenance_mode = redirect_to maintenance_path

  def maintenance_mode_activated? = ENV["MAINTENANCE_MODE"] == "true"

  def admin_secret_access? = request.headers["X-Admin-Secret-Access"] == ENV["ADMIN_SECRET_ACCESS"]

  def basic_auth
    authenticate_or_request_with_http_basic do |u1, p1|
      u2, p2 = ENV["BASIC_AUTH"].split(":")
      u1 == u2 && p1 == p2
    end
  end

  def layout_by_resource
    if devise_controller?
      case resource_name
      when :administrator
        "admin"
      else
        "devise"
      end
    else
      "application"
    end
  end

  def after_sign_in_path_for(resource)
    case resource
    when Administrator
      stored_location_for(resource) || admin_root_path
    when User
      stored_location_for(resource) || edit_account_user_path
    else
      stored_location_for(resource)
    end
  end

  def authenticated_user_or_administrator
    current_user || "unknown"
  end

  def current_organization
    @current_organization ||= Organization.first
  end
end
