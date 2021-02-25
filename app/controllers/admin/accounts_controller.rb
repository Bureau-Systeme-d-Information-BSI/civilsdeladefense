# frozen_string_literal: true

class Admin::AccountsController < Admin::BaseController
  skip_load_and_authorize_resource

  before_action :set_administrator, only: %i[show change_password change_email
    update update_password update_email]

  layout "admin/account"

  # POST /admin/account
  # POST /admin/account.json
  def show
  end

  # PATCH/PUT /admin/account/1
  # PATCH/PUT /admin/account/1.json
  def update
    respond_to do |format|
      if @administrator.update(administrator_params)
        format.html { redirect_to %i[admin account], notice: t(".success") }
        format.json { render :show, status: :ok, location: @administrator }
      else
        format.html { render :show }
        format.json { render json: @administrator.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_password
    respond_to do |format|
      if @administrator.update_with_password(administrator_password_params)
        # Sign in the user by passing validation in case their password changed
        bypass_sign_in(@administrator, scope: :administrator)

        format.html { redirect_to %i[change_password admin account], notice: t(".success") }
        format.json { render :show, status: :ok, location: @administrator }
      else
        format.html { render :change_password }
        format.json { render json: @administrator.errors, status: :unprocessable_entity }
      end
    end
  end

  def change_email
  end

  def update_email
    respond_to do |format|
      if @administrator.update(administrator_email_params)
        format.html { redirect_to %i[change_email admin account], notice: t(".success") }
        format.json { render :show, status: :ok, location: @administrator }
      else
        format.html { render :change_email }
        format.json { render json: @administrator.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_administrator
    @administrator = current_administrator
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def administrator_params
    params.require(:administrator).permit(
      :title,
      :first_name,
      :last_name,
      :photo,
      {
        supervisor_administrator_attributes: %i[email employer_id ensure_employer_is_set]
      },
      grand_employer_administrator_attributes: %i[email employer_id ensure_employer_is_set]
    )
  end

  def administrator_password_params
    params.require(:administrator).permit(:current_password, :password, :password_confirmation)
  end

  def administrator_email_params
    params.require(:administrator).permit(:email)
  end
end
