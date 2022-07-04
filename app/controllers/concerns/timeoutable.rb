# frozen_string_literal: true

module Timeoutable
  extend ActiveSupport::Concern

  included do
    before_action :set_timeout_in
  end

  private

  def set_timeout_in
    @timeout_in = current_user.timeout_in.in_milliseconds if user_signed_in?
  end
end
