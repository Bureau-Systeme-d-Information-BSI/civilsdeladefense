# frozen_string_literal: true

class Admin::Settings::Administrators::ConfirmationInstructionsController < Admin::BaseController
  skip_load_and_authorize_resource
  before_action :set_administrator
  before_action :authorize_confirmation_instruction

  def create
    @administrator.send_confirmation_instructions
    respond_to do |format|
      format.html { redirect_to %i[admin settings root], notice: t(".success") }
      format.json { head :no_content }
    end
  end

  private

  def set_administrator
    @administrator = Administrator.find(params[:administrator_id])
  end

  def authorize_confirmation_instruction
    authorize! :manage, @administrator
  end
end
