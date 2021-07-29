# frozen_string_literal: true

require "turbolinks/redirection"

class Admin::BaseController < ApplicationController
  include Turbolinks::Redirection

  before_action :authenticate_administrator!
  before_action :set_current_administrator
  load_and_authorize_resource
  layout "admin"

  protected

  def current_ability
    @current_ability ||= Ability.new(current_administrator)
  end

  def authenticated_user_or_administrator
    current_administrator || "unknown"
  end

  def set_current_administrator
    Current.administrator = current_administrator
  end
end
