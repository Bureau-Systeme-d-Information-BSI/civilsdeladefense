# frozen_string_literal: true

class Admin::NotificationsController < Admin::BaseController
  layout "admin/account"

  def index
    @notifications = {}
    Notification::KINDS.each do |kind|
      @notifications[kind] = current_administrator.notifications.where(daily: false, kind: kind)
    end
  end
end
