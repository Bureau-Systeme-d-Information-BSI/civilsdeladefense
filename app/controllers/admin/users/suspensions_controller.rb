# frozen_string_literal: true

class Admin::Users::SuspensionsController < Admin::BaseController
  skip_load_and_authorize_resource
  before_action :set_user
  before_action :authorize_suspension

  def create
    reason = params.require(:user).permit(:suspension_reason).fetch(:suspension_reason)
    reason = nil if reason.blank?
    @user.suspend!(reason)
    redirect_back_or_to([:admin, @user], notice: t(".success"))
  end

  def destroy
    @user.unsuspend!
    redirect_back_or_to([:admin, @user], notice: t(".success"))
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def authorize_suspension
    authorize! :suspend, @user
  end
end
