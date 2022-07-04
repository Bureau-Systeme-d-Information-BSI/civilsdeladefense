# frozen_string_literal: true

class DomainValidationsController < ApplicationController
  respond_to :txt

  def show
    @env_value = ENV["DOMAIN_VALIDATION_#{params[:file_name].upcase}]"
  end
end
