class ApplicationController < ActionController::Base

  before_action :basic_auth, if: -> { ENV['BASIC_AUTH'].present? }

  layout :layout_by_resource

  private

    def basic_auth
      authenticate_or_request_with_http_basic do |u1, p1|
        u2, p2 = ENV['BASIC_AUTH'].split(":")
        u1 == u2 && p1 == p2
      end
    end

    def layout_by_resource
      if devise_controller? && resource_name == :administrator
        'admin'
      else
        'application'
      end
    end

    def after_sign_in_path_for(resource)
      if resource.is_a?(Administrator)
        stored_location_for(resource) || admin_root_path
      elsif resource.is_a?(User)
        stored_location_for(resource) || account_root_path
      else
        stored_location_for(resource)
      end
    end

    def authenticated_user_or_administrator
      if current_user
        current_user
      elsif current_administrator
        current_administrator
      else
        'unknown'
      end
    end
end
