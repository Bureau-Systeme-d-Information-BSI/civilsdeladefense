class Admin::BaseController < ApplicationController

  before_action :authenticate_administrator!
  load_and_authorize_resource
  layout 'admin'

  protected

    def current_ability
      @current_ability ||= Ability.new(current_administrator)
    end
end
