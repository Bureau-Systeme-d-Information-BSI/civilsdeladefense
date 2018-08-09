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
      if devise_controller? && resource_name == :admin
        'admin'
      else
        'application'
      end
    end
end
