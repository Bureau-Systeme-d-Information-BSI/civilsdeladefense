# frozen_string_literal: true

class Account::UsersController < Account::BaseController
  before_action :set_user, only: %i[show change_password change_email
                                    update update_password update_email
                                    destroy]

  def show
    @user_for_password_change = User.new
    @user_for_email_change = User.new
    @user_for_deletion = User.new
  end

  def update
    @user = current_user
    @job_application = current_user.job_applications.find params[:job_application_id]
    @file_name = user_params.keys.first
    respond_to do |format|
      if @user.update(user_params)
        @user.update_column "#{@file_name}_is_validated", 0
        format.html { redirect_to %i[account user], notice: t('.success') }
        format.js {}
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.js {}
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_password
    respond_to do |format|
      if @user.update_with_password(user_password_params)
        # Sign in the user by passing validation in case their password changed
        bypass_sign_in(@user, scope: :user)

        format.html { redirect_to %i[account user], notice: t('.success') }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html do
          @user_for_password_change = @user
          @user_for_email_change = User.new
          @user_for_deletion = User.new
          render :show
        end
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def change_email
  end

  def update_email
    respond_to do |format|
      if @user.update(user_email_params)
        format.html { redirect_to %i[account user], notice: t('.success') }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html do
          @user_for_password_change = User.new
          @user_for_deletion = User.new
          @user_for_email_change = @user
          render :show
        end
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if @user.destroy_with_password(user_destroy_params[:current_password])
      redirect_to root_url, notice: t('.success')
    else
      @user_for_password_change = User.new
      @user_for_email_change = User.new
      @user_for_deletion = @user

      render :want_destroy
    end
  end

  private

  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(permitted_fields)
  end

  def permitted_fields
    User::FILES
  end

  def user_password_params
    params.require(:user).permit(:current_password, :password, :password_confirmation)
  end

  def user_email_params
    params.require(:user).permit(:email)
  end

  def user_destroy_params
    params.require(:user).permit(:current_password)
  end
end
