# frozen_string_literal: true

class DomainValidationsController < ApplicationController
  respond_to :txt

  def show
    @env_var_name = "DOMAIN_VALIDATION_#{params[:file_name].upcase}"
  end
end
