# frozen_string_literal: true

class Admin::AccountsController < Admin::BaseController
  skip_load_and_authorize_resource

  before_action :set_administrator, only: %i[show update]

  layout "admin/account"

  # POST /admin/account
  # POST /admin/account.json
  def show
  end

  def photo
    administrator = Administrator.find(params[:id])

    send_data(
      administrator.photo.big.read,
      filename: administrator.photo.filename,
      type: administrator.photo.content_type
    )
  end

  # PATCH/PUT /admin/account/1
  # PATCH/PUT /admin/account/1.json
  def update
    respond_to do |format|
      if update_admin
        notice = @administrator.unconfirmed_email_previously_changed? ? t(".success_new_email") : t(".success")
        format.html { redirect_to %i[admin account], notice: }
        format.json { render :show, status: :ok, location: @administrator }
      else
        format.html { render :show }
        format.json { render json: @administrator.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_admin
    if password_changed?
      updated = @administrator.update_with_password(administrator_params)
      # Sign in the user by passing validation in case their password changed
      bypass_sign_in(@administrator, scope: :administrator) if updated
      updated
    else
      @administrator.update(administrator_params_without_password)
    end
  end

  private

  def set_administrator
    @administrator = current_administrator
  end

  def password_changed?
    params.dig(:administrator, :current_password).present? ||
      params.dig(:administrator, :password).present? ||
      params.dig(:administrator, :password_confirmation).present?
  end

  def administrator_params
    params.require(:administrator).permit(
      :first_name,
      :last_name,
      :photo,
      :email,
      :current_password,
      :password,
      :password_confirmation
    )
  end

  def administrator_params_without_password
    administrator_params.except(:current_password, :password, :password_confirmation)
  end
end
