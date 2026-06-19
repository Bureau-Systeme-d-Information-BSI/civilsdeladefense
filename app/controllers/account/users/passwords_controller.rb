# frozen_string_literal: true

class Account::Users::PasswordsController < Account::BaseController
  def edit
    @user_for_password_change = current_user

    render "account/users/change_password"
  end

  def update
    if current_user.update_with_password(password_params)
      bypass_sign_in(current_user, scope: :user) # Sign in the user by passing validation in case their password changed

      redirect_to account_user_path, notice: t(".success")
    else
      @user_for_password_change = current_user
      @user_for_email_change = User.new
      @user_for_deletion = User.new
      render "account/users/show"
    end
  end

  private

  def password_params
    params.expect(user: %i[current_password password password_confirmation])
  end
end
